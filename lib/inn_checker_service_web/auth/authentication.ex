defmodule InnCheckerServiceWeb.Authentication do
  @moduledoc """
  Implementation module for Guardian and functions for authentication.
  """

  use Guardian, otp_app: :inn_checker_service
  alias InnCheckerService.{Accounts, Accounts.User}

  def subject_for_token(resource, _claims) do
    {:ok, to_string(resource.login)}
  end

  def resource_from_claims(%{"sub" => login}) do
    case Accounts.get_by_login(login) do
      nil -> {:error, :resource_not_found}
      account -> {:ok, account}
    end
  end

  def log_in(conn, user) do
    __MODULE__.Plug.sign_in(conn, user)
  end

  def logged?(conn) do
    __MODULE__.Plug.authenticated?(conn)
  end

  def current_user(conn) do
    __MODULE__.Plug.current_resource(conn)
  end

  def authenticate(%User{} = user, password) do
    authenticate(
      user,
      password,
      Argon2.verify_pass(password, user.encrypted_password)
    )
  end

  def authenticate(nil, password) do
    authenticate(nil, password, Argon2.no_user_verify())
  end

  defp authenticate(user, _password, true) do
    {:ok, user}
  end

  defp authenticate(_user, _password, false) do
    {:error, :invalid_credentials}
  end

  def log_out(conn) do
    __MODULE__.Plug.sign_out(conn)
  end
end
