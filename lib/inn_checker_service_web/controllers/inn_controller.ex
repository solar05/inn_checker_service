defmodule InnCheckerServiceWeb.InnController do
  use InnCheckerServiceWeb, :controller
  import Ecto.Query, warn: false
  alias InnCheckerService.Papers.Document
  alias InnCheckerService.Documents.Inn
  alias InnCheckerServiceWeb.Services.IpService
  alias InnCheckerService.Repo

  def index(conn, params) do
    page =
      Document
      |> order_by(desc: :inserted_at)
      |> Repo.paginate(params)

    render(conn, "index.html", inns: page.entries, page: page)
  end

  def new(conn, params) do
    page =
      Document
      |> order_by(desc: :inserted_at)
      |> Repo.paginate(params)

    render(conn, "new.html", inns: page.entries, page: page)
  end

  def create(conn, %{"inn" => inn_params}) do
    Map.put(inn_params, "client", IpService.extract_ip(conn))

    case Documents.create_inn(inn_params) do
      {:ok, inn} ->
        conn
        |> put_flash(:info, "Inn created successfully.")
        |> redirect(to: Routes.inn_path(conn, :show, inn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inn = Documents.get_inn!(id)
    render(conn, "show.html", inn: inn)
  end

  def delete(conn, %{"id" => id}) do
    inn = Documents.get_inn!(id)
    {:ok, _inn} = Documents.delete_inn(inn)

    conn
    |> put_flash(:success, "ИНН успешно удален.")
    |> redirect(to: Routes.inn_path(conn, :index))
  end
end
