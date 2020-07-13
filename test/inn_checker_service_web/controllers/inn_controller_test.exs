defmodule InnCheckerServiceWeb.InnControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Documents

  @ten_digit_valid_inn "7743013901"

  @create_attrs %{client: "some client", number: @ten_digit_valid_inn, state: "some state"}
  @invalid_attrs %{client: nil, number: nil, state: nil}

  def fixture(:inn) do
    {:ok, inn} = Documents.create_inn(@create_attrs)
    inn
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
