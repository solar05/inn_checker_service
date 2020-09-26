defmodule InnCheckerServiceWeb.UserControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Accounts

  @operator %{"account" => %{login: "ops", password: "56tYKP56a"}}
  @admin %{"account" => %{login: "adm", password: "3Egt5EPGS"}}
  @invalid_user %{"account" => %{login: "user", password: "passwd"}}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "Login user" do
    test "Login as admin", %{conn: conn} do
      conn = post(conn, "/login", @admin)
      assert redirected_to(conn) == "/admin/documents"
    end

    test "Login as operator", %{conn: conn} do
      conn = post(conn, "/login", @operator)
      assert redirected_to(conn) == "/admin/documents"
    end
  end
end
