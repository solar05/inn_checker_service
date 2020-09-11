defmodule InnCheckerService.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :client, :string
      add :number, :string
      add :state, :string
      add :type, :string

      timestamps()
    end
  end
end
