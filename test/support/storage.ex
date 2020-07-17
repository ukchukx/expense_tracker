defmodule ExpenseTracker.Storage do
  alias ExpenseTracker.Repo
  @doc """
  Clear the event store and read store databases
  """
  def reset! do
    :ok = Application.stop(:expense_tracker)
    :ok = Application.stop(:commanded)
    reset_event_store()
    reset_read_store()
    {:ok, _} = Application.ensure_all_started(:expense_tracker)
    :ok
  end

  defp reset_event_store do
    ExpenseTracker.EventStore.config
    |> EventStore.Config.parse
    |> EventStore.Config.default_postgrex_opts
    |> Postgrex.start_link
    |> elem(1)
    |> EventStore.Storage.Initializer.reset!
  end

  defp reset_read_store do
    :expense_tracker
    |> Application.get_env(Repo)
    |> Postgrex.start_link
    |> elem(1)
    |> Postgrex.query!(truncate_read_tables_query(), [])
  end

  defp truncate_read_tables_query do
    Application.get_env(:expense_tracker, Repo)[:truncate_read_tables_query]
  end
end
