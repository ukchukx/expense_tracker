defmodule ExpenseTracker.Repo.Migrations.CreateExpenseItems do
  use Ecto.Migration

  def change do
    create table(:expense_items, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :budget_id, :uuid
      add :line_item_id, :uuid
      add :description, :string
      add :date, :string
      add :amount, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:expense_items, [:user_id])
    create index(:expense_items, [:line_item_id])
  end
end
