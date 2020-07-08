defmodule InnCheckerService.DocumentsTest do
  use InnCheckerService.DataCase

  alias InnCheckerService.Documents

  describe "inns" do
    alias InnCheckerService.Documents.Inn

    @valid_attrs %{client: "some client", number: "some number", state: "some state"}
    @update_attrs %{
      client: "some updated client",
      number: "some updated number",
      state: "some updated state"
    }
    @invalid_attrs %{client: nil, number: nil, state: nil}

    def inn_fixture(attrs \\ %{}) do
      {:ok, inn} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Documents.create_inn()

      inn
    end

    test "list_inns/0 returns all inns" do
      inn = inn_fixture()
      assert Documents.list_inns() == [inn]
    end

    test "get_inn!/1 returns the inn with given id" do
      inn = inn_fixture()
      assert Documents.get_inn!(inn.id) == inn
    end

    test "create_inn/1 with valid data creates a inn" do
      assert {:ok, %Inn{} = inn} = Documents.create_inn(@valid_attrs)
      assert inn.client == "some client"
      assert inn.number == "some number"
      assert inn.state == "some state"
    end

    test "create_inn/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_inn(@invalid_attrs)
    end

    test "update_inn/2 with valid data updates the inn" do
      inn = inn_fixture()
      assert {:ok, %Inn{} = inn} = Documents.update_inn(inn, @update_attrs)
      assert inn.client == "some updated client"
      assert inn.number == "some updated number"
      assert inn.state == "some updated state"
    end

    test "update_inn/2 with invalid data returns error changeset" do
      inn = inn_fixture()
      assert {:error, %Ecto.Changeset{}} = Documents.update_inn(inn, @invalid_attrs)
      assert inn == Documents.get_inn!(inn.id)
    end

    test "delete_inn/1 deletes the inn" do
      inn = inn_fixture()
      assert {:ok, %Inn{}} = Documents.delete_inn(inn)
      assert_raise Ecto.NoResultsError, fn -> Documents.get_inn!(inn.id) end
    end

    test "change_inn/1 returns a inn changeset" do
      inn = inn_fixture()
      assert %Ecto.Changeset{} = Documents.change_inn(inn)
    end
  end
end
