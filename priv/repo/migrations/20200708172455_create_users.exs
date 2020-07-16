defmodule InnCheckerService.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :login, :string
      add :password, :string, virtual: true
      add :encrypted_password, :string
      add :role, :string

      timestamps()
    end
  end
end
