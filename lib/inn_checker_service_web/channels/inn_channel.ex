defmodule InnCheckerServiceWeb.InnChannel do
  use Phoenix.Channel
  alias InnCheckerService.Documents
  alias InnCheckerServiceWeb.Services.InnChecker

  def join("inn:checks", %{"params" => %{"token" => token, "client" => client}}, socket) do
    if Phoenix.Token.verify(token, "client auth", client) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("inn:checks", _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_inn", %{"body" => body, "client" => client}, socket) do
    inn_params = %{number: body, client: client}
    # check if banned
    case Documents.create_inn(inn_params) do
      {:ok, inn} ->
        Task.async(InnChecker, :check_inn, [inn])

        broadcast!(socket, "inn_added", %{
          body: body,
          id: inn.id,
          date: to_string(inn.inserted_at)
        })

        {:noreply, socket}

      {:error, _} ->
        broadcast!(socket, "inn_error", %{body: "Некорректный формат инн!"})
        {:noreply, socket}
    end
  end
end
