defmodule InnCheckerServiceWeb.UserController do
  use InnCheckerServiceWeb, :controller

  def index(conn, _params) do
    ban_list = GenServer.call(:ban_server, {:ban_list, %{}})
    render(conn, "index.html", users: ban_list)
  end

  def create(conn, %{"client" => client}) do
    GenServer.call(:ban_server, {:unban, %{client: client}})

    conn
    |> put_flash(:success, "Пользователь успешно разблокирован!")
    |> redirect(to: Routes.user_path(conn, :index))
  end

  def delete(conn, %{"client" => client, "minutes" => minutes}) do
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
  end
end
