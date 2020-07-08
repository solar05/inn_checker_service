defmodule InnCheckerService.Repo.Migrations.CreateInns do
  use Ecto.Migration

  def change do
    create table(:inns) do
      add :number, :string
      add :client, :string
      add :state, :string

      timestamps()
    end

  end
end
