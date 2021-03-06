defmodule InnCheckerServiceWeb.PageController do
  use InnCheckerServiceWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> redirect(to: Routes.document_path(conn, :new))
  end

  def about(conn, _params) do
    conn
    |> redirect(to: Routes.document_path(conn, :new))
  end
end
