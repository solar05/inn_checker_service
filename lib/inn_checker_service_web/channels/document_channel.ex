defmodule InnCheckerServiceWeb.DocumentChannel do
  use Phoenix.Channel
  alias InnCheckerService.Documents
  alias InnCheckerService.Papers
  alias InnCheckerServiceWeb.Services.DocumentChecker

  def join("document:checks", %{"params" => %{"token" => token, "client" => client}}, socket) do
    if Phoenix.Token.verify(token, "client auth", client) do
      {:ok, socket}
    else
      {:error, %{reason: "Unauthorized channel user"}}
    end
  end

  def handle_in(
        "new_document",
        %{"body" => body, "client" => client, "token" => token, "type" => type},
        socket
      ) do
    if Phoenix.Token.verify(token, "client auth", client) do
      case GenServer.call(:ban_server, {:banned?, %{client: client}}) do
        :not_banned ->
          document_params = %{number: body, client: client, type: type}

          case Papers.create_document(document_params) do
            {:ok, document} ->
              Task.async(DocumentChecker, :check_document, [document])

              broadcast!(socket, "document_added", %{
                body: body,
                type: type,
                id: document.id,
                date: to_string(Timex.shift(document.inserted_at, hours: 3))
              })

              {:noreply, socket}

            {:error, _} ->
              broadcast!(socket, "document_error", %{body: "Некорректный формат документа!"})
              {:noreply, socket}
          end

        :banned ->
          broadcast!(socket, "user_banned", %{})
          {:noreply, socket}
      end
    else
      {:error, %{reason: "Unauthorized document check"}}
    end
  end

  def handle_in("new_document", _body, _socket) do
    {:error, %{reason: "Unauthorized document check"}}
  end
end
