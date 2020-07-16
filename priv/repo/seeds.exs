# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InnCheckerService.Repo.insert!(%InnCheckerService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule InnCheckerService.DatabaseSeeder do
  alias InnCheckerService.Repo
  alias InnCheckerService.Accounts

  # InnCheckerService.Accounts.create_user(%{login: "hey", password: "ho", role: "admin"})

  @operator %{login: "ops", password: "56tYKP56aZ", role: "operator"}
  @admin %{login: "adm", password: "3Egt5EPGSX8L", role: "admin"}

  def run(_) do
    Accounts.create_user(@str)
    insert_users()
  end

  def insert_users do
    Accounts.create_user(@operator)
    Accounts.create_user(@admin)
  end

  def clear do
    Repo.delete!(@operator)
    Repo.delete!(@admin)
  end
end
