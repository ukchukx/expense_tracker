use Mix.Config

config :expense_tracker, env: :test

config :bcrypt_elixir, :log_rounds, 4

config :commanded, assert_receive_event_timeout: 5_000

config :expense_tracker, ExpenseTracker.EventStore,
  database: {:system, "ET_TEST_EVENT_DB"},
  pool_size: 5

config :expense_tracker, ExpenseTracker.Repo,
  database: {:system, "ET_TEST_READ_DB"},
  pool_size: 5

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :expense_tracker, ExpenseTracker.Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
