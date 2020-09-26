defmodule InnCheckerServiceWeb.UserController do
  use InnCheckerServiceWeb, :controller

  alias InnCheckerServiceWeb.Authentication
  import InnCheckerService.Accounts.User

  def index(conn, _params) do
    user = Authentication.current_user(conn)

    if can?(user, "index_users") do
      ban_list = GenServer.call(:ban_server, {:ban_list, %{}})
      render(conn, "index.html", users: ban_list)
    else
      conn
      |> put_flash(:error, "Недостаточно прав.")
      |> redirect(to: Routes.document_path(conn, :index))
    end
  end

  def create(conn, %{"client" => client}) do
    user = Authentication.current_user(conn)

    if can?(user, "unban_users") do
      GenServer.call(:ban_server, {:unban, %{client: client}})

      conn
      |> put_flash(:success, "Пользователь успешно разблокирован!")
      |> redirect(to: Routes.user_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Недостаточно прав.")
      |> redirect(to: Routes.document_path(conn, :index))
    end
  end

  def delete(conn, %{"client" => client, "minutes" => minutes}) do
    user = Authentication.current_user(conn)

    if can?(user, "ban_users") do
      if minutes != "" and Regex.match?(~r(^[0-9]+$), minutes) do
        case GenServer.call(
               :ban_server,
               {:ban_user, %{client: client, minutes: String.to_integer(minutes)}}
             ) do
          :ok ->
            conn
            |> put_flash(:success, "Пользователь успешно заблокирован!")
            |> redirect(to: Routes.user_path(conn, :index))

          :banned ->
            conn
            |> put_flash(:info, "Пользователь был заблокирован ранее!")
            |> redirect(to: Routes.user_path(conn, :index))

          _ ->
            conn
            |> put_flash(:error, "Произошла ошибка!")
            |> redirect(to: Routes.user_path(conn, :index))
        end
      else
        conn
        |> put_flash(:error, "Произошла ошибка!")
        |> redirect(to: Routes.user_path(conn, :index))
      end
    else
      conn
      |> put_flash(:error, "Недостаточно прав.")
      |> redirect(to: Routes.document_path(conn, :index))
    end
  end
end
