# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :inn_checker_service,
  ecto_repos: [InnCheckerService.Repo],
  env: Mix.env()

# Configures the endpoint
config :inn_checker_service, InnCheckerServiceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4f0Fk0wOM1eTuU5/nr/+n6e5ZAVMKWSxY0U4/r/ldQjV+f/XokhRnUrePdR72Y0v",
  render_errors: [view: InnCheckerServiceWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: InnCheckerService.PubSub,
  live_view: [signing_salt: "vDH7MXiE"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :inn_checker_service, InnCheckerServiceWeb.Authentication,
  issuer: "inn_checker_service",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
