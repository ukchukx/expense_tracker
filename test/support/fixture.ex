defmodule ExpenseTracker.Fixture do
  alias ExpenseTracker.{Accounts, Budgets}

  def fixture(resource, attrs \\ [])

  def fixture(:user, attrs), do: create_user(attrs)

  def fixture(:budget, attrs), do: create_budget(attrs)

  defp create_user(attrs \\ []), do: attrs |> ExpenseTracker.Factory.build_user_params |> Accounts.create_user

  defp create_budget(attrs \\ []) do
    attrs |> ExpenseTracker.Factory.build_budget_params |> Budgets.create_budget(user_context())
  end

  def user_context do
    {:ok, user}  = create_user()

    user_context(user)
  end

  def user_context(%{} = user), do: %{user: user}
end
