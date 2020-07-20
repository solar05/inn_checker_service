defmodule InnCheckerServiceWeb.InnControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Documents

  @ten_digit_valid_inn "7743013901"

  @create_attrs %{client: "some client", number: @ten_digit_valid_inn, state: "some state"}

  def fixture(:inn) do
    {:ok, inn} = Documents.create_inn(@create_attrs)
    inn
  end

  describe "delete inn" do
    setup [:create_inn]

    test "deletes chosen inn", %{conn: conn, inn: inn} do
      conn = delete(conn, Routes.inn_path(conn, :delete, inn))
      assert redirected_to(conn) == "/login"
    end
  end

  defp create_inn(_) do
    inn = fixture(:inn)
    %{inn: inn}
  end
end
