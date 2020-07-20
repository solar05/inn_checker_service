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
  alias InnCheckerService.Accounts

  # InnCheckerService.Accounts.create_user(%{login: "hey", password: "ho", role: "admin"})

  @operator %{login: "ops", password: "56tYKP56a", role: "operator"}
  @admin %{login: "adm", password: "3Egt5EPGS", role: "admin"}

  if !Accounts.get_by_login("adm") do
    Accounts.create_user(@admin)
  end

  if !Accounts.get_by_login("ops") do
    Accounts.create_user(@operator)
  end
end
