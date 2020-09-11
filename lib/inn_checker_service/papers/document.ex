defmodule InnCheckerService.Papers.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @types ~w(inn snils)

  schema "documents" do
    field :client, :string
    field :number, :string
    field :state, :string, default: "created"
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:client, :number, :state, :type])
    |> validate_inclusion(:type, @types)
    |> validate_document
  end

  defp validate_document(changeset) do
    document = get_field(changeset, :number)
    type = get_field(changeset, :type)

    case type do
      "inn" ->
        if is_binary(document) and is_inn_length_valid(document) and is_document_numeric(document) do
          changeset
        else
          add_error(changeset, :number, "Invalid document format!")
        end

      _ ->
        add_error(changeset, :type, "Invalid document type!")
    end
  end

  def is_inn_length_valid(document) do
    document_length = String.length(document)
    document_length == 10 or document_length == 12
  end

  def is_document_numeric(inn) do
    Regex.match?(~r(^[0-9]+$), inn)
  end
end
