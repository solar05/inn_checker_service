defmodule InnCheckerServiceWeb.DocumentAcessTest do
  use InnCheckerServiceWeb.FeatureCase, async: true

  test "Accessing a inns administration without logging in", %{session: session} do
    visit(session, "/admin/documents")
    assert current_path(session) == "/login"
  end

  test "Accessing a users administration without logging in", %{session: session} do
    visit(session, "/admin/users")
    assert current_path(session) == "/login"
  end
end
