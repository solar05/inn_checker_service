defmodule InnCheckerServiceWeb.InnControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Documents

  @create_attrs %{client: "some client", number: "some number", state: "some state"}
  @update_attrs %{
    client: "some updated client",
    number: "some updated number",
    state: "some updated state"
  }
  @invalid_attrs %{client: nil, number: nil, state: nil}

  def fixture(:inn) do
    {:ok, inn} = Documents.create_inn(@create_attrs)
    inn
  end

  describe "index" do
    test "lists all inns", %{conn: conn} do
      conn = get(conn, Routes.inn_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Inns"
    end
  end

  describe "new inn" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.inn_path(conn, :new))
      assert html_response(conn, 200) =~ "New Inn"
    end
  end

  describe "create inn" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.inn_path(conn, :create), inn: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.inn_path(conn, :show, id)

      conn = get(conn, Routes.inn_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Inn"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.inn_path(conn, :create), inn: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Inn"
    end
  end

  describe "edit inn" do
    setup [:create_inn]

    test "renders form for editing chosen inn", %{conn: conn, inn: inn} do
      conn = get(conn, Routes.inn_path(conn, :edit, inn))
      assert html_response(conn, 200) =~ "Edit Inn"
    end
  end

  describe "update inn" do
    setup [:create_inn]

    test "redirects when data is valid", %{conn: conn, inn: inn} do
      conn = put(conn, Routes.inn_path(conn, :update, inn), inn: @update_attrs)
      assert redirected_to(conn) == Routes.inn_path(conn, :show, inn)

      conn = get(conn, Routes.inn_path(conn, :show, inn))
      assert html_response(conn, 200) =~ "some updated client"
    end

    test "renders errors when data is invalid", %{conn: conn, inn: inn} do
      conn = put(conn, Routes.inn_path(conn, :update, inn), inn: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Inn"
    end
  end

  describe "delete inn" do
    setup [:create_inn]

    test "deletes chosen inn", %{conn: conn, inn: inn} do
      conn = delete(conn, Routes.inn_path(conn, :delete, inn))
      assert redirected_to(conn) == Routes.inn_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.inn_path(conn, :show, inn))
      end
    end
  end

  defp create_inn(_) do
    inn = fixture(:inn)
    %{inn: inn}
  end
end
