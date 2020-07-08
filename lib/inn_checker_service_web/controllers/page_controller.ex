defmodule InnCheckerServiceWeb.PageController do
  use InnCheckerServiceWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
