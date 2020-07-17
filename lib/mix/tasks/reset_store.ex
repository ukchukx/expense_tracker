defmodule Mix.Tasks.ResetStore do
  alias ExpenseTracker.Repo

  require Logger

  use Mix.Task

  @shortdoc "Reset read & event stores"

  def run(args), do: reset_read_models!(args)

  def reset_event_store, do: event_store_conn() |> EventStore.Storage.Initializer.reset!

  defp reset_read_models!(args) do
    [:postgrex, :ecto] |> Enum.each(&Application.ensure_all_started/1)
    Repo.start_link()

    Logger.info("Resetting subscriptions table...")
    reset_subscription_table()

    if "everything" in args do
      Logger.info("Resetting event tables...")
      reset_event_store()
    end

    reset_read_store()

    Logger.info("Done")
  end

  defp reset_read_store do
    :stash
    |> Application.get_env(Repo)
    |> Postgrex.start_link
    |> elem(1)
    |> Postgrex.query(truncate_read_tables_query(), [])
  end

  defp truncate_read_tables_query do
    Application.get_env(:stash, Repo)[:truncate_read_tables_query]
  end

  defp reset_subscription_table do
    Postgrex.query(event_store_conn(), truncate_subscription_table_query(), [], pool: DBConnection.Poolboy)
  end

  defp event_store_conn do
    ExpenseTracker.EventStore.config
    |> EventStore.Config.parse
    |> EventStore.Config.default_postgrex_opts
    |> Postgrex.start_link
    |> elem(1)
  end

  defp truncate_subscription_table_query, do: "TRUNCATE TABLE subscriptions RESTART IDENTITY;"
end
