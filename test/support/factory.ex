defmodule ExpenseTracker.Factory do
  alias ExpenseTracker.Commands.{CreateUser, CreateExpenseItem, CreateBudget}
  alias ExpenseTracker.Aggregates.{Budget, ExpenseItem, User}
  alias ExpenseTracker.Support.Utils

  use ExMachina

  def user_factory do
    %{
      id: Ecto.UUID.generate(),
      password: Faker.Lorem.sentence(2..4),
      email: Faker.Internet.email(),
      active: true
    }
  end

  def budget_factory do
    start_date = Date.utc_today()

    %{
      budget_id: Ecto.UUID.generate(),
      user_id: Ecto.UUID.generate(),
      name: Utils.budget_name(start_date),
      start_date: start_date,
      end_date: Faker.Date.forward(30),
      line_items: [
        %{amount: 10_000, description: Faker.Lorem.word(), id: Ecto.UUID.generate()},
        %{amount: 20_000, description: Faker.Lorem.word(), id: Ecto.UUID.generate()}
      ]
    }
  end

  def expense_item_factory do
    %{
      budget_id: Ecto.UUID.generate(),
      expense_item_id: Ecto.UUID.generate(),
      line_item_id: Ecto.UUID.generate(),
      description: Faker.Lorem.sentence(1..2),
      amount: 10_000,
      date: 4 |> Faker.Date.backward() |> Date.to_string
    }
  end

  def create_user_command_factory(attrs \\ []), do: struct(CreateUser, build_user_params(attrs))

  def user_aggregate_factory(attrs \\ []) do
    params =
      :create_user_command
      |> build(attrs)
      |> Utils.to_map
      |> Map.drop([:user_id])
      |> Map.put(:id, Ecto.UUID.generate())

    struct(User, params)
  end

  def build_user_params(attrs \\ []), do: build(:user, attrs)


  def create_budget_command_factory(attrs \\ []), do: struct(CreateBudget, build_budget_params(attrs))

  def budget_aggregate_factory(attrs \\ []) do
    params =
      :create_budget_command
      |> build(attrs)
      |> Utils.to_map
      |> Map.drop([:budget_id])
      |> Map.put(:id, Ecto.UUID.generate())

    struct(Budget, params)
  end

  def build_budget_params(attrs \\ []), do: build(:budget, attrs)


  def create_expense_item_command_factory(attrs \\ []), do: struct(CreateExpenseItem, build_expense_item_params(attrs))

  def expense_item_aggregate_factory(attrs \\ []) do
    params =
      :create_expense_item_command
      |> build(attrs)
      |> Utils.to_map
      |> Map.drop([:expense_item_id])
      |> Map.put(:id, Ecto.UUID.generate())

    struct(ExpenseItem, params)
  end

  def build_expense_item_params(attrs \\ []), do: build(:expense_item, attrs)
end
