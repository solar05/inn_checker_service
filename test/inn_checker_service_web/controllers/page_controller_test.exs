defmodule InnCheckerServiceWeb.PageControllerTest do
  use InnCheckerServiceWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert conn.status == 302
  end
end
