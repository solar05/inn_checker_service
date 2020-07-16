defmodule InnCheckerServiceWeb.Authentication.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :inn_checker_service,
    error_handler: InnCheckerServiceWeb.Authentication.ErrorHandler,
    module: InnCheckerServiceWeb.Authentication

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource, allow_blank: true
end
