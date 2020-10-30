defmodule ExpenseTracker.Budgets do
  alias ExpenseTracker.Commands.{CreateBudget, DeleteBudget, CreateExpenseItem, DeleteExpenseItem}
  alias ExpenseTracker.Queries.{ById, Budgets, ExpenseItems}
  alias ExpenseTracker.{Commands, Queries}
  alias ExpenseTracker.Projections.{Budget, ExpenseItem}
  alias ExpenseTracker.Support.Utils


  def build_create_budget_command(%{start_date: d} = attrs, %{user: %{id: id}} = _context) do
    items =
      attrs
      |> Map.get(:line_items)
      |> case do
        nil -> nil
        items ->
          items
          |> Enum.map(fn
            %{id: _} = x -> x
            x -> Map.put(x, :id, Ecto.UUID.generate())
          end)
      end

    attrs =
      attrs
      |> Map.put(:user_id, id)
      |> Map.put(:name, Utils.budget_name(d))
      |> Map.put(:budget_id, Ecto.UUID.generate())
      |> Map.put(:line_items, items)

    CreateBudget
    |> struct(attrs)
    |> CreateBudget.add_un_budgeted_item
  end

  def build_create_expense_item_command(%{} = attrs, %{budget: %{id: id}, line_item: %{id: item_id}} = _context) do
    attrs =
      attrs
      |> Map.put(:budget_id, id)
      |> Map.put(:line_item_id, item_id)
      |> Map.put(:expense_item_id, Ecto.UUID.generate())

    struct(CreateExpenseItem, attrs)
  end

  def create_budget(%{start_date: d} = attrs, %{user: %{id: user_id}} = context) do
    with budget_name = Utils.budget_name(d),
         {:error, :not_found} <- by_name_and_user(budget_name, user_id),
         {:ok, %{id: id}} <- attrs |> build_create_budget_command(context) |> Commands.dispatch do
      budget_by_id(id)
    else
      {:ok, _} = existing_budget -> existing_budget
      response -> response
    end
  end

  def create_expense_item(%{} = attrs, %{budget: %{}, line_item: %{}} = context) do
    attrs
    |> build_create_expense_item_command(context)
    |> Commands.dispatch
    |> case do
      {:ok, %{id: id}} -> expense_item_by_id(id)
      response -> response
    end
  end

  def delete_budget(%{id: id} = _budget) do
    with {:ok, _} <- budget_by_id(id),
         {:ok, _state}	<- DeleteBudget |> struct(%{budget_id: id}) |> Commands.dispatch do
      :ok
    else
      res -> res
    end
  end

  def delete_expense_item(%{id: id} = _budget) do
    with {:ok, _} <- expense_item_by_id(id),
         {:ok, _state}	<- DeleteExpenseItem |> struct(%{expense_item_id: id}) |> Commands.dispatch do
      :ok
    else
      res -> res
    end
  end

  def budget_by_id(id), do: Budget |> ById.one(id) |> Queries.fetch_one

  def by_name_and_user(name, user_id), do: name |> Budgets.by_name_and_user(user_id) |> Queries.fetch_one

  def budgets_for_user(user_id),
    do: user_id |> Budgets.for_user |> Budgets.latest_first |> Queries.fetch_all

  def expense_item_by_id(id), do: ExpenseItem |> ById.one(id) |> Queries.fetch_one

  def expense_items_for_budget(budget_id), do: budget_id |> ExpenseItems.for_budget |> Queries.fetch_all

  def expense_items_for_line_item(line_item_id), do: line_item_id |> ExpenseItems.for_line_item |> Queries.fetch_all

  def expense_items_for_line_items(line_item_ids), do: line_item_ids |> ExpenseItems.for_line_items |> Queries.fetch_all

  def expense_items_for_user(user_id), do: user_id |> ExpenseItems.for_user |> Queries.fetch_all

  def current_budget?(budget) do
    today = Date.utc_today()
    today.year == budget.start_date.year and today.month == budget.start_date.month
  end

  def calculate_line_item_expensed_values_for_budgets(budgets) when is_list(budgets) do
    Enum.map(budgets, &calculate_line_item_expensed_values_for_budget/1)
  end

  def calculate_line_item_expensed_values_for_budget(budget = %{line_items: items}) do
    expense_items_for_budget =
      items
      |> Enum.map(&(&1["id"]))
      |> expense_items_for_line_items

    items =
      items
      |> Enum.map(fn %{"id" => item_id} = item ->
        total_expense_for_line_item =
          expense_items_for_budget
          |> Enum.filter(&(&1.line_item_id == item_id))
          |> expense_items_total

        Map.put(item, "expensed", total_expense_for_line_item)
      end)

    %{budget | line_items: items}
  end

  defp expense_items_total(items), do: Enum.reduce(items, 0, fn %{amount: amount}, sum -> sum + amount end)

end
