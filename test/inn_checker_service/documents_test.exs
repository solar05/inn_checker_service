defmodule InnCheckerService.DocumentsTest do
  use InnCheckerService.DataCase

  alias InnCheckerService.Documents

  @ten_digit_valid_inn "7743013901"
  @ten_digit_invalid_inn "7743013902"
  @twelwe_digit_valid_inn "732897853530"
  @twelwe_digit_invalid_inn "732897853531"

  describe "inns" do
    alias InnCheckerService.Documents.Inn

    @valid_attrs %{client: "some client", number: @ten_digit_valid_inn, state: "some state"}
    @update_attrs %{
      client: "some updated client",
      number: @twelwe_digit_valid_inn,
      state: "some updated state"
    }
    @invalid_attrs %{client: nil, number: @ten_digit_invalid_inn, state: nil}

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
      assert inn.number == @ten_digit_valid_inn
      assert inn.state == "some state"
    end

    test "create_inn/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Documents.create_inn(@invalid_attrs)
    end

    test "update_inn/2 with valid data updates the inn" do
      inn = inn_fixture()
      assert {:ok, %Inn{} = inn} = Documents.update_inn(inn, @update_attrs)
      assert inn.client == "some updated client"
      assert inn.number == @twelwe_digit_valid_inn
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

    test "ten_digit_valid_inn" do
      assert Inn.is_control_sum_valid(@valid_attrs)
    end

    test "ten_digit_invalid_inn" do
      assert Inn.is_control_sum_valid(@invalid_attrs) == false
    end

    test "twelwe_digit_valid_inn" do
      assert Inn.is_control_sum_valid(%{number: @twelwe_digit_valid_inn})
    end

    test "twelwe_digit_invalid_inn" do
      assert Inn.is_control_sum_valid(%{number: @twelwe_digit_invalid_inn}) == false
    end

    test "invalid_inn_length" do
      assert Inn.is_control_sum_valid(%{number: "73"}) == false
    end
  end
end
