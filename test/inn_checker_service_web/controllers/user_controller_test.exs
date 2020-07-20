defmodule InnCheckerServiceWeb.UserControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Accounts

  @create_attrs %{login: "some login", password: "some password", role: "some role"}
  @update_attrs %{
    login: "some updated login",
    password: "some updated password",
    role: "some updated role"
  }
  @invalid_attrs %{login: nil, password: nil, role: nil}

  @admin_login "adm"
  @admin_role "admin"
  @ops_login "ops"
  @ops_role "operator"

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  #  describe "index" do
  #    test "lists all users", %{conn: conn} do
  #      conn = get(conn, Routes.user_path(conn, :index))
  #      assert html_response(conn, 200) =~ "Listing Users"
  #    end
  #  end

  # defp create_user(_) do
  #  user = fixture(:user)
  #  %{user: user}
  # end
end
