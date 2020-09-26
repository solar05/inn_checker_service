defmodule InnCheckerServiceWeb.Api.DocumentController do
  use InnCheckerServiceWeb, :controller
  import Ecto.Query, warn: false
  alias InnCheckerService.Papers
  alias InnCheckerServiceWeb.Services.IpService
  alias InnCheckerServiceWeb.Services.DocumentChecker

  def create(conn, params) do
    client = IpService.extract_ip(conn)
    document_params = Map.put(params, "client", client)

    case GenServer.call(:ban_server, {:banned?, %{client: client}}) do
      :not_banned ->
        case Papers.create_document(document_params) do
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

      :banned ->
        conn
        |> put_status(403)
        |> render("user_banned.json", [])
    end
  end

  def show(conn, %{"type" => type, "number" => number}) do
    [document] = Papers.get_document!(number, type)

    conn
    |> put_status(200)
    |> render("document.json", document: document)
  end
end
