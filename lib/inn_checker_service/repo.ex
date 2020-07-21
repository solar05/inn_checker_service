defmodule InnCheckerService.Repo do
  use Ecto.Repo,
    otp_app: :inn_checker_service,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10
end
