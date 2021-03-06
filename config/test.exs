use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :inn_checker_service, InnCheckerService.Repo,
  username: "postgres",
  password: "postgres",
  database: "inn_checker_service_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :inn_checker_service, InnCheckerServiceWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :inn_checker_service, InnCheckerServiceWeb.Endpoint, server: true

config :wallaby, driver: Wallaby.Chrome, js_errors: false

config :inn_checker_service, :sql_sandbox, true
