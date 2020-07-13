defmodule InnCheckerServiceWeb.InnController do
  use InnCheckerServiceWeb, :controller

  alias InnCheckerService.Documents
  alias InnCheckerService.Documents.Inn
  alias InnCheckerServiceWeb.Services.IpService

  def index(conn, _params) do
    inns = Documents.list_inns()
    render(conn, "index.html", inns: inns)
  end

  def new(conn, _params) do
    changeset = Documents.change_inn(%Inn{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"inn" => inn_params}) do
    Map.put(inn_params, "client", IpService.extract_ip(conn))

    case Documents.create_inn(inn_params) do
      {:ok, inn} ->
        # Task.async(InnChecker, :check_inn, [inn, socket])
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

  def edit(conn, %{"id" => id}) do
    inn = Documents.get_inn!(id)
    changeset = Documents.change_inn(inn)
    render(conn, "edit.html", inn: inn, changeset: changeset)
  end

  def update(conn, %{"id" => id, "inn" => inn_params}) do
    inn = Documents.get_inn!(id)

    case Documents.update_inn(inn, inn_params) do
      {:ok, inn} ->
        conn
        |> put_flash(:info, "Inn updated successfully.")
        |> redirect(to: Routes.inn_path(conn, :show, inn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", inn: inn, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inn = Documents.get_inn!(id)
    {:ok, _inn} = Documents.delete_inn(inn)

    conn
    |> put_flash(:info, "Inn deleted successfully.")
    |> redirect(to: Routes.inn_path(conn, :index))
  end
end
