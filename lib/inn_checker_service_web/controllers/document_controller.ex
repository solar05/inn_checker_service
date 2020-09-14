defmodule InnCheckerServiceWeb.DocumentController do
  use InnCheckerServiceWeb, :controller
  import Ecto.Query, warn: false
  alias InnCheckerService.Papers.Document
  alias InnCheckerService.Papers
  alias InnCheckerServiceWeb.Services.IpService
  alias InnCheckerService.Repo

  def index(conn, params) do
    page =
      Document
      |> order_by(desc: :inserted_at)
      |> Repo.paginate(params)

    render(conn, "index.html", documents: page.entries, page: page)
  end

  def new(conn, params) do
    page =
      Document
      |> order_by(desc: :inserted_at)
      |> Repo.paginate(params)

    render(conn, "new.html", documents: page.entries, page: page)
  end

  def create(conn, %{"document" => document_params}) do
    Map.put(document_params, "client", IpService.extract_ip(conn))

    case Papers.create_document(document_params) do
      {:ok, inn} ->
        conn
        |> put_flash(:info, "Document created successfully.")
        |> redirect(to: Routes.document_path(conn, :show, inn))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    document = Papers.get_document!(id)
    render(conn, "show.html", document: document)
  end

  def delete(conn, %{"id" => id}) do
    document = Papers.get_document!(id)
    {:ok, _document} = Papers.delete_document(document)

    conn
    |> put_flash(:success, "Документ успешно удален.")
    |> redirect(to: Routes.document_path(conn, :index))
  end
end
