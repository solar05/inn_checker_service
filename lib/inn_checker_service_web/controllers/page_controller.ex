defmodule InnCheckerServiceWeb.PageController do
  use InnCheckerServiceWeb, :controller
  alias InnCheckerService.Documents

  def index(conn, _params) do
    inns = Documents.last_50()
    render(conn, "index.html", inns: inns)
  end
end
