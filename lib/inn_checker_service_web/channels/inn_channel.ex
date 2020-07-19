defmodule InnCheckerServiceWeb.InnChannel do
  use Phoenix.Channel
  alias InnCheckerService.Documents
  alias InnCheckerServiceWeb.Services.InnChecker

  def join("inn:checks", %{"params" => %{"token" => token, "client" => client}}, socket) do
    if Phoenix.Token.verify(token, "client auth", client) do
      {:ok, socket}
    else
      {:error, %{reason: "Unauthorized channel user"}}
    end
  end

  def handle_in("new_inn", %{"body" => body, "client" => client, "token" => token}, socket) do
    if Phoenix.Token.verify(token, "client auth", client) do
      case GenServer.call(:ban_server, {:banned?, %{client: client}}) do
        :not_banned ->
          inn_params = %{number: body, client: client}

          case Documents.create_inn(inn_params) do
            {:ok, inn} ->
              Task.async(InnChecker, :check_inn, [inn])

              broadcast!(socket, "inn_added", %{
                body: body,
                id: inn.id,
                date: to_string(Timex.shift(inn.inserted_at, hours: 3))
              })

              {:noreply, socket}

            {:error, _} ->
              broadcast!(socket, "inn_error", %{body: "Некорректный формат инн!"})
              {:noreply, socket}
          end

        :banned ->
          broadcast!(socket, "user_banned", %{})
          {:noreply, socket}
      end
    else
      {:error, %{reason: "Unauthorized inn check"}}
    end
  end

  def handle_in("new_inn", _body, _socket) do
    {:error, %{reason: "Unauthorized inn check"}}
  end
end
