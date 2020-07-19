defmodule ExpenseTracker.Aggregates.ExpenseItemTest do
  alias ExpenseTracker.Events.{ExpenseItemCreated, ExpenseItemDeleted}
  alias ExpenseTracker.Commands.DeleteExpenseItem
  alias ExpenseTracker.Support.Utils
  alias ExpenseTracker.Aggregates.ExpenseItem
  alias ExpenseTracker.AggregateCase

  use AggregateCase, aggregate: ExpenseItem

  @moduletag aggregates: :expense_item
  @moduletag :expense_item

  describe "CreateExpenseItem" do
    test "should emit ExpenseItemCreated" do
      command = build(:create_expense_item_command)

      assert_events(command, [struct(ExpenseItemCreated, Utils.to_map(command))])
    end
  end

  describe "DeleteExpenseItem" do
    test "should emit ExpenseItemDeleted" do
      %{id: expense_item_id} = aggregate = build(:expense_item_aggregate)

      assert_events(
        aggregate,
        %DeleteExpenseItem{expense_item_id: expense_item_id},
        [%ExpenseItemDeleted{expense_item_id: expense_item_id}]
      )
    end
  end
end
