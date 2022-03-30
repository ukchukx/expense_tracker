defmodule ExpenseTracker.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, :uuid
      add :name, :string, size: 100
      add :currency, :string
      add :start_date, :date
      add :end_date, :date
      add :line_items, {:array, :map}, default: []

      timestamps(type: :utc_datetime)
    end

    create index(:budgets, [:user_id])
    create index(:budgets, [:name])
  end
end
