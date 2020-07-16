defmodule InnCheckerServiceWeb.PageController do
  use InnCheckerServiceWeb, :controller
  alias InnCheckerService.Documents
  alias InnCheckerServiceWeb.Services.IpService

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    conn
    |> redirect(to: Routes.inn_path(conn, :index))
  end
end
