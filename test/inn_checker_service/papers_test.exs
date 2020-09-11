defmodule InnCheckerService.PapersTest do
  use InnCheckerService.DataCase
  alias InnCheckerService.Papers

  @ten_digit_valid_inn "7743013901"
  @ten_digit_invalid_inn "7743013902"
  @twelwe_digit_valid_inn "732897853530"
  @twelwe_digit_invalid_inn "732897853531"

  describe "documents" do
    alias InnCheckerService.Papers.Document

    @valid_attrs %{
      client: "some client",
      number: @ten_digit_valid_inn,
      state: "some state",
      type: "inn"
    }
    @invalid_attrs %{client: nil, number: nil, state: nil, type: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Papers.create_document()

      document
    end

    test "list_documents/0 returns all documents" do
      document = document_fixture()
      assert Papers.list_documents() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Papers.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Papers.create_document(@valid_attrs)
      assert document.client == "some client"
      assert document.number == @ten_digit_valid_inn
      assert document.state == "some state"
      assert document.type == "inn"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Papers.create_document(@invalid_attrs)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Papers.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Papers.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Papers.change_document(document)
    end
  end
end
