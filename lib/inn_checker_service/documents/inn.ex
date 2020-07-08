defmodule InnCheckerService.Documents.Inn do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inns" do
    field :client, :string
    field :number, :string
    field :state, :string

    timestamps()
  end

  @doc false
  def changeset(inn, attrs) do
    inn
    |> cast(attrs, [:number, :client, :state])
    |> validate_required([:number, :client, :state])
  end
end
