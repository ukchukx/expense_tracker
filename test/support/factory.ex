defmodule ExpenseTracker.Factory do
  alias ExpenseTracker.Commands.CreateUser
  alias ExpenseTracker.Aggregates.User
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
end
