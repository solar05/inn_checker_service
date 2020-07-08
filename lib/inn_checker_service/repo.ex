defmodule InnCheckerService.Repo do
  use Ecto.Repo,
    otp_app: :inn_checker_service,
    adapter: Ecto.Adapters.Postgres
end
