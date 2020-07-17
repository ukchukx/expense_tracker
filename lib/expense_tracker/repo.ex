defmodule ExpenseTracker.Repo do
  use Ecto.Repo,
    otp_app: :expense_tracker,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    {:ok, Confex.Resolver.resolve!(config)}
  end
end
