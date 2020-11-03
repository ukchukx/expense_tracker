defmodule ExpenseTracker.Support.Migrate do
  require Logger

  def run do
     Logger.info("Running migrations...")
     path = Application.app_dir(:expense_tracker, "priv/repo/migrations")
     Ecto.Migrator.run(ExpenseTracker.Repo, path, :up, all: true)
     Logger.info("Done running migrations")
  end

end
