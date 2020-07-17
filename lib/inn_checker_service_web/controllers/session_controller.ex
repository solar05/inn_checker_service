defmodule InnCheckerServiceWeb.SessionController do
  use InnCheckerServiceWeb, :controller

  alias InnCheckerService.Accounts
  alias InnCheckerServiceWeb.Authentication

  def new(conn, _params) do
    if Authentication.current_user(conn) do
      redirect(conn, to: "/")
    else
      render(
        conn,
        :new,
        changeset: Accounts.change_user(),
        action: Routes.session_path(conn, :create)
      )
    end

    # render(conn, :new, changeset: conn, action: "/login")
  end

  def create(conn, %{"account" => %{"login" => login, "password" => password}}) do
    case login |> Accounts.get_by_login() |> Authentication.authenticate(password) do
      {:ok, account} ->
        conn
        |> Authentication.log_in(account)
        |> redirect(to: Routes.inn_path(conn, :index))

      {:error, :invalid_credentials} ->
        conn
        |> put_flash(:error, "Incorrect login or password")
        |> new(%{})
    end
  end

  def delete(conn, _params) do
    conn
    |> Authentication.log_out()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
