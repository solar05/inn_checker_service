defmodule InnCheckerServiceWeb.InnController do
  use InnCheckerServiceWeb, :controller

  alias InnCheckerService.Documents
  alias InnCheckerService.Documents.Inn
  alias InnCheckerServiceWeb.Services.IpService
  alias InnCheckerServiceWeb.Authentication

  def index(conn, _params) do
    inns = Documents.last_100()
    IO.inspect(Authentication.logged?(conn))
    IO.inspect(Authentication.current_user(conn))
    render(conn, "index.html", inns: inns)
  end

  def new(conn, _params) do
    inns = Documents.last_100()
    IO.inspect(System.get_env("GUARDIAN_SECRET_KEY"))
    render(conn, "new.html", inns: inns)
  end

  def create(conn, %{"inn" => inn_params}) do
    IO.inspect(inn_params)
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
    # current_account = Authentication.get_current_account(conn)
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
    IO.inspect(inn)
    {:ok, _inn} = Documents.delete_inn(inn)

    conn
    |> put_flash(:success, "ИНН успешно удален.")
    |> redirect(to: Routes.inn_path(conn, :index))
  end
end
