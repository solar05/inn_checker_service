defmodule InnCheckerServiceWeb.LayoutView do
  import InnCheckerService.Accounts.User
  use InnCheckerServiceWeb, :view
  alias InnCheckerServiceWeb.Authentication

  def logged?(conn) do
    Authentication.logged?(conn)
  end

  def user(conn) do
    Authentication.get_current_account(conn)
  end
end
