defmodule InnCheckerServiceWeb.UserControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Accounts

  @operator %{"account" => %{login: "ops", password: "56tYKP56a"}}
  @admin %{"account" => %{login: "adm", password: "3Egt5EPGS"}}
  @invalid_user %{"account" => %{login: "user", password: "passwd"}}
  @client "127.0.0.2"
  @ban_time "10"

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "Login user" do
    test "Login as admin", %{conn: conn} do
      response = post(conn, "/login", @admin)
      assert response.status == 302
      assert redirected_to(response) == "/admin/documents"
    end

    test "Login as operator", %{conn: conn} do
      response = post(conn, "/login", @operator)
      assert response.status == 302
      assert redirected_to(response) == "/admin/documents"
    end

    test "Login as non existing user", %{conn: conn} do
      response = post(conn, "/login", @invalid_user)
      assert response.status == 200
    end
  end

  describe "Admin operations" do
    test "Go to users", %{conn: conn} do
      conn = post(conn, "/login", @admin)
      response = get(conn, "/admin/users")
      assert response.status == 200
    end

    test "Go to documents", %{conn: conn} do
      conn = post(conn, "/login", @admin)
      response = get(conn, "/admin/documents")
      assert response.status == 200
    end

    test "Ban user", %{conn: conn} do
      conn = post(conn, "/login", @admin)
      response = post(conn, Routes.user_path(conn, :delete, @client), %{"minutes" => @ban_time})
      assert response.status == 302
      assert redirected_to(response) == Routes.user_path(conn, :index)
    end
  end

  describe "Operator operations" do
    test "Go to users", %{conn: conn} do
      conn = post(conn, "/login", @operator)
      response = get(conn, "/admin/users")
      assert response.status == 302
    end

    test "Go to documents", %{conn: conn} do
      conn = post(conn, "/login", @operator)
      response = get(conn, "/admin/documents")
      assert response.status == 200
    end
  end
end
