defmodule InnCheckerServiceWeb.Api.DocumentController do
  use InnCheckerServiceWeb, :controller
  import Ecto.Query, warn: false
  alias InnCheckerService.Papers
  alias InnCheckerServiceWeb.Services.IpService
  alias InnCheckerServiceWeb.Services.DocumentChecker

  def create(conn, params) do
    Map.put(params, "client", IpService.extract_ip(conn))

    case Papers.create_document(params) do
      {:ok, document} ->
        checked_document = DocumentChecker.check_document_api(document)

        conn
        |> put_status(200)
        |> render("document.json", document: checked_document)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(422)
        |> render("document_error.json", errors: changeset.errors)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Papers.get_document!(id)
    render(conn, "document.json", document: document)
  end
end
