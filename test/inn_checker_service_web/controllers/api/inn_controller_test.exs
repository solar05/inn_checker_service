defmodule InnCheckerServiceWeb.Api.InnControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Documents

  @ten_digit_valid_inn "7743013901"
  @ten_digit_invalid_inn "7743013904"

  @create_attrs %{client: "some client", number: @ten_digit_valid_inn, state: "created"}

  def fixture(:inn) do
    {:ok, inn} = Documents.create_inn(@create_attrs)
    inn
  end

  describe "Inn api checks" do
    setup [:create_inn]

    test "Check valid inn", %{conn: conn} do
      conn = post(conn, Routes.api_inn_path(conn, :create), %{number: @ten_digit_valid_inn})
      assert %{"state" => "correct"} = json_response(conn, 200)
    end

    test "Check invalid inn", %{conn: conn} do
      conn = post(conn, Routes.api_inn_path(conn, :create), %{number: @ten_digit_invalid_inn})
      assert %{"state" => "incorrect"} = json_response(conn, 200)
    end

    test "Check invalid inn attr", %{conn: conn} do
      conn = post(conn, Routes.api_inn_path(conn, :create), %{number: "12321"})
      assert json_response(conn, 422)
    end
  end

  describe "Show inn api" do
    setup [:create_inn]

    test "Show chosen inn", %{conn: conn, inn: inn} do
      conn = get(conn, Routes.api_inn_path(conn, :show, inn))
      assert json_response(conn, 200)
    end
  end

  defp create_inn(_) do
    inn = fixture(:inn)
    %{inn: inn}
  end
end
