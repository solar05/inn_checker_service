defmodule InnCheckerServiceWeb.DocumentControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Papers

  @ten_digit_valid_inn "7743013901"

  @create_attrs %{
    client: "some client",
    number: @ten_digit_valid_inn,
    state: "some state",
    type: "inn"
  }

  def fixture(:document) do
    {:ok, document} = Papers.create_document(@create_attrs)
    document
  end

  describe "delete inn" do
    setup [:create_document]

    test "deletes chosen inn", %{conn: conn, document: document} do
      conn = delete(conn, Routes.document_path(conn, :delete, document))
      assert redirected_to(conn) == "/login"
    end
  end

  defp create_document(_) do
    document = fixture(:document)
    %{document: document}
  end
end
