defmodule InnCheckerService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :password, :string
      add :role, :string

      timestamps()
    end

  end
end
