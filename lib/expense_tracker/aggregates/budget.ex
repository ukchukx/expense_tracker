defmodule ExpenseTracker.Aggregates.Budget do
  defstruct [:id, :user_id, :name, :start_date, :end_date, :line_items, deleted: false]

  alias ExpenseTracker.Commands.{CreateBudget, DeleteBudget}
  alias ExpenseTracker.Events.{BudgetCreated, BudgetDeleted}

  @behaviour Commanded.Aggregates.AggregateLifespan

  def after_event(%BudgetDeleted{}), do: 5_000
  def after_event(_), do: :infinity

  def after_command(_command), do: :infinity
  def after_error(_error), do: :stop

  def execute(%__MODULE__{}, %CreateBudget{} = c) do
    %BudgetCreated{
      user_id: c.user_id,
      budget_id: c.budget_id,
      name: c.name,
      line_items: c.line_items,
      start_date: c.start_date,
      end_date: c.end_date
    }
  end

  def execute(%__MODULE__{id: id}, %DeleteBudget{}), do: %BudgetDeleted{budget_id: id}

  def apply(%__MODULE__{} = budget, %BudgetCreated{} = e) do
    %__MODULE__{
      budget
      | id: e.budget_id,
        user_id: e.user_id,
        name: e.name,
        start_date: e.start_date,
        end_date: e.end_date,
        line_items: e.line_items
    }
  end

  def apply(%__MODULE__{} = budget, %BudgetDeleted{}) do
    %__MODULE__{budget | deleted: true}
  end
end
