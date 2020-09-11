defmodule InnCheckerServiceWeb.Api.DocumentControllerTest do
  use InnCheckerServiceWeb.ConnCase

  alias InnCheckerService.Papers

  @ten_digit_valid_inn "7743013901"
  @ten_digit_invalid_inn "7743013904"

  @create_attrs %{
    client: "127.0.0.1",
    number: @ten_digit_valid_inn,
    state: "created",
    type: "inn"
  }

  def fixture(:document) do
    {:ok, document} = Papers.create_document(@create_attrs)
    document
  end

  describe "Document api checks" do
    setup [:create_document]

    test "Check valid document", %{conn: conn} do
      conn =
        post(conn, Routes.api_document_path(conn, :create), %{
          number: @ten_digit_valid_inn,
          type: "inn"
        })

      assert %{"state" => "correct"} = json_response(conn, 200)
    end

    test "Check invalid document", %{conn: conn} do
      conn =
        post(conn, Routes.api_document_path(conn, :create), %{
          number: @ten_digit_invalid_inn,
          type: "inn"
        })

      assert %{"state" => "incorrect"} = json_response(conn, 200)
    end

    test "Check invalid document attr", %{conn: conn} do
      conn = post(conn, Routes.api_document_path(conn, :create), %{number: "12321"})
      assert json_response(conn, 422)
    end
  end

  describe "Show document api" do
    setup [:create_document]

    test "Show chosen document", %{conn: conn, document: document} do
      conn = get(conn, Routes.api_document_path(conn, :show, document))
      assert json_response(conn, 200)
    end
  end

  defp create_document(_) do
    document = fixture(:document)
    %{document: document}
  end
end
