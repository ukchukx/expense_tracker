defmodule ExpenseTracker.Support.SetupDatabase do
  alias ExpenseTracker.Repo
  alias EventStore.Tasks.{Create, Init}
  require Logger

  def run do
    create_read_db()
    setup_event_store()
    run_migrations()
  end

  defp create_read_db do
    Logger.info("Creating read database...")

    case Repo.__adapter__.storage_up(Repo.config()) do
     :ok -> Logger.info("Read database created")
     {:error, :already_up} -> Logger.info("Read database already created")
     {:error, term} -> Logger.error("Read database could not be created: #{inspect term}")
    end
  end

  defp setup_event_store do
    Logger.info("Setting up event store...")

    [event_store] = Application.get_env(:expense_tracker , :event_stores)
    config = event_store.config()
    Create.exec(config, [])
    Init.exec(event_store, config, [])
  end

  defp run_migrations do
    Logger.info("Running read database migrations...")

    path = Application.app_dir(:expense_tracker, "priv/repo/migrations")
    Ecto.Migrator.run(Repo, path, :up, all: true)
    Logger.info("Done running migrations")
  end
end
