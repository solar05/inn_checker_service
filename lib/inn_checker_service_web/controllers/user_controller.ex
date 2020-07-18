defmodule InnCheckerServiceWeb.UserController do
  use InnCheckerServiceWeb, :controller

  alias InnCheckerService.Accounts
  alias InnCheckerService.Accounts.User
  alias InnCheckerService.Documents
  alias InnCheckerServiceWeb.Services.BanServer

  def index(conn, _params) do
    users = Documents.clients()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"client" => client}) do
    IO.inspect(client)

    conn
    |> put_flash(:success, "Пользователь успешно разблокирован!")
    |> redirect(to: Routes.user_path(conn, :index))

    # case Accounts.create_user(user_params) do
    # {:ok, user} ->
    #   conn
    #   |> put_flash(:info, "User created successfully.")
    #   |> redirect(to: Routes.user_path(conn, :show, user))

    #  {:error, %Ecto.Changeset{} = changeset} ->
    #    render(conn, "new.html", changeset: changeset)
    # end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.html", user: user)
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"client" => client, "minutes" => minutes}) do
    case GenServer.call(:ban_server, {:ban_user, %{client: client, minutes: minutes}}) do
      :ok ->
        conn
        |> put_flash(:success, "Пользователь успешно заблокирован!")
        |> redirect(to: Routes.user_path(conn, :index))

      _ ->
        conn
        |> put_flash(:error, "Произошла ошибка!")
        |> redirect(to: Routes.user_path(conn, :index))
    end
  end
end
