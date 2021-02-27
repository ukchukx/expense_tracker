defmodule Mix.Tasks.ResetStore do
  @moduledoc "Reset read & event stores"
  @dialyzer {:nowarn_function, reset_subscription_table: 0}

  alias EventStore.Storage.Initializer
  alias ExpenseTracker.Repo

  require Logger

  use Mix.Task

  def run(args), do: reset_read_models!(args)

  def reset_event_store, do: Initializer.reset(event_store_conn())

  defp reset_read_models!(args) do
    Enum.each([:postgrex, :ecto], &Application.ensure_all_started/1)
    Repo.start_link()

    Logger.info("Resetting subscriptions table...")

    try do
      reset_subscription_table()
    rescue
      _ -> :ok
    end

    if "everything" in args do
      Logger.info("Resetting event tables...")
      reset_event_store()
    end

    reset_read_store()

    Logger.info("Done")
  end

  defp reset_read_store do
    :expense_tracker
    |> Application.get_env(Repo)
    |> Postgrex.start_link()
    |> case do
      {:ok, pid} -> Postgrex.query(pid, truncate_read_tables_query(), [])
      err -> err
    end
  end

  defp truncate_read_tables_query do
    Application.get_env(:expense_tracker, Repo)[:truncate_read_tables_query]
  end

  defp reset_subscription_table do
    Postgrex.query(
      event_store_conn(),
      "TRUNCATE TABLE subscriptions RESTART IDENTITY;",
      [],
      pool: DBConnection.Poolboy
    )
  end

  defp event_store_conn do
    ExpenseTracker.EventStore.config()
    |> EventStore.Config.parse()
    |> EventStore.Config.default_postgrex_opts()
    |> Postgrex.start_link()
    |> elem(1)
  end
end
