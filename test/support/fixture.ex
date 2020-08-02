defmodule ExpenseTracker.Fixture do
  alias ExpenseTracker.{Accounts, Budgets}

  def fixture(resource, attrs \\ [])

  def fixture(:user, attrs), do: create_user(attrs)

  def fixture(:budget, attrs), do: create_budget(attrs)

  def fixture(:expense_item, attrs), do: create_expense_item(attrs)

  defp create_user(attrs \\ []), do: attrs |> ExpenseTracker.Factory.build_user_params |> Accounts.create_user

  defp create_budget(attrs \\ []) do
    attrs |> ExpenseTracker.Factory.build_budget_params |> Budgets.create_budget(user_context())
  end

  defp create_expense_item(attrs \\ []) do
    attrs |> ExpenseTracker.Factory.build_expense_item_params |> Budgets.create_expense_item(line_item_context())
  end

  def user_context do
    {:ok, user}  = create_user()

    user_context(user)
  end

  def user_context(%{} = user), do: %{user: user}

  def budget_context do
    {:ok, budget}  = create_budget()

    budget_context(budget)
  end

  def budget_context(%{} = budget), do: %{budget: budget}

  def line_item_context do
    context = %{budget: %{line_items: [%{"id" => id} | _]}} = budget_context()

    Map.put(context, :line_item, %{id: id})
  end
end
