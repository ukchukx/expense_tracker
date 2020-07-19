defmodule ExpenseTracker.Aggregates.BudgetTest do
  alias ExpenseTracker.Events.{BudgetCreated, BudgetDeleted}
  alias ExpenseTracker.Commands.DeleteBudget
  alias ExpenseTracker.Support.Utils
  alias ExpenseTracker.Aggregates.Budget
  alias ExpenseTracker.AggregateCase

  use AggregateCase, aggregate: Budget

  @moduletag aggregates: :budget
  @moduletag :budget

  describe "CreateBudget" do
    test "should emit BudgetCreated" do
      command = build(:create_budget_command)

      assert_events(command, [struct(BudgetCreated, Utils.to_map(command))])
    end
  end

  describe "DeleteBudget" do
    test "should emit BudgetDeleted" do
      %{id: budget_id} = aggregate = build(:budget_aggregate)

      assert_events(
        aggregate,
        %DeleteBudget{budget_id: budget_id},
        [%BudgetDeleted{budget_id: budget_id}]
      )
    end
  end
end
