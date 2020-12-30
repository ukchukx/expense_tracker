# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :expense_tracker, :router,
  timeout: 10_000

config :expense_tracker,
  ecto_repos: [ExpenseTracker.Repo],
  event_stores: [ExpenseTracker.EventStore]


config :commanded_ecto_projections, repo: ExpenseTracker.Repo

config :commanded, event_store_adapter: Commanded.EventStore.Adapters.EventStore

config :expense_tracker, ExpenseTracker.CommandedApp,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: ExpenseTracker.EventStore
  ],
  pub_sub: :local,
  registry: :local

# Configures the endpoint
config :expense_tracker, ExpenseTracker.Web.Endpoint,
  url: [host: {:system, "ET_DNS_ADDR"}],
  secret_key_base: {:system, "ET_SECRET_KEY_BASE"},
  render_errors: [view: ExpenseTracker.Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ExpenseTracker.PubSub,
  live_view: [signing_salt: "9Pvt7FL1"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  utc_log: true,
  truncate: :infinity

config :expense_tracker, ExpenseTracker.Repo,
  truncate_read_tables_query: """
    TRUNCATE TABLE
      users,
      budgets,
      expense_items,
      projection_versions
    RESTART IDENTITY;
    """,
  migration_timestamps: [type: :utc_datetime_usec],
  username: {:system, "ET_DB_USER"},
  password: {:system, "ET_DB_PASS"},
  database: {:system, "ET_READ_DB"},
  hostname: {:system, "ET_DB_HOST"},
  pool_size: {:system, :integer, "ET_DB_POOL_SIZE"},
  charset: "utf8mb4",
  collation: "utf8mb4_unicode_ci"

config :expense_tracker, ExpenseTracker.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: {:system, "ET_DB_USER"},
  password: {:system, "ET_DB_PASS"},
  database: {:system, "ET_EVENT_DB"},
  hostname: {:system, "ET_DB_HOST"},
  pool_size: {:system, :integer, "ET_DB_POOL_SIZE"},
  charset: "utf8mb4",
  collation: "utf8mb4_unicode_ci"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
