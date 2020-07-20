defmodule InnCheckerService.AccountsTest do
  use InnCheckerService.DataCase
  alias InnCheckerService.Accounts

  describe "users" do
    alias InnCheckerService.Accounts.User

    @valid_attrs %{login: "login", password: "3Egt5EPGS", role: "admin"}

    @admin_login "adm"
    @admin_role "admin"
    @ops_login "ops"
    @ops_role "operator"

    def user_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(@valid_attrs)
      user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, user} = Accounts.create_user(@valid_attrs)
      assert user.login == "login"
      assert user.role == "admin"
    end

    test "Fetch admin account" do
      assert user = Accounts.get_by_login("adm")
      assert user.login == @admin_login
      assert user.role == @admin_role
    end

    test "Fetch operator account" do
      assert user = Accounts.get_by_login("ops")
      assert user.login == @ops_login
      assert user.role == @ops_role
    end

    #    test "delete_user/1 deletes the user" do
    #      user = user_fixture()
    #      assert {:ok, %User{}} = Accounts.delete_user(user)
    #      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    #    end

    #    test "change_user/1 returns a user changeset" do
    #      user = user_fixture()
    #      assert %Ecto.Changeset{} = Accounts.change_user(user)
    #    end
  end
end
