defmodule ExpenseTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :active, :boolean
      add :email, :string
      add :password, :string

      timestamps(type: :utc_datetime)
    end
    create index(:users, [:email])
  end
end
