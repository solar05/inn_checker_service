defmodule InnCheckerServiceWeb.Api.InnController do
  use InnCheckerServiceWeb, :controller
  import Ecto.Query, warn: false
  alias InnCheckerService.Documents
  alias InnCheckerServiceWeb.Services.IpService
  alias InnCheckerServiceWeb.Services.InnChecker

  def create(conn, params) do
    Map.put(params, "client", IpService.extract_ip(conn))

    case Documents.create_inn(params) do
      {:ok, inn} ->
        checked_inn = InnChecker.check_inn_api(inn)

        conn
        |> put_status(200)
        |> render("inn.json", inn: checked_inn)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> render("inn_error.json", errors: changeset.errors)
    end
  end

  def show(conn, %{"id" => id}) do
    inn = Documents.get_inn!(id)
    render(conn, "inn.json", inn: inn)
  end
end
