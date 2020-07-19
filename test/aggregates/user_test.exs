defmodule ExpenseTracker.Aggregates.UserTest do
  alias ExpenseTracker.Events.{UserCreated, UserDisabled, UserEnabled, UserEmailChanged, UserPasswordChanged}
  alias ExpenseTracker.Commands.{DisableUser, EnableUser, UpdateUser}
  alias ExpenseTracker.Support.Utils
  alias ExpenseTracker.Aggregates.User
  alias ExpenseTracker.AggregateCase

  use AggregateCase, aggregate: User

  @moduletag aggregates: :user
  @moduletag :user

  describe "CreateUser" do
    test "should emit UserCreated" do
      command = build(:create_user_command)
      command = Map.put(command, :hashed_password, command.password)

      assert_events(command, [struct(UserCreated, Utils.to_map(command))])
    end
  end

  describe "DisableUser" do
    test "should emit UserDisabled if user is not disabled" do
      %{id: user_id} = aggregate = build(:user_aggregate)

      assert_events(
        aggregate,
        %DisableUser{user_id: user_id},
        [%UserDisabled{user_id: user_id}]
      )
    end

    test "should not emit any event if user is disabled" do
      %{id: user_id} = aggregate = build(:user_aggregate)

      assert_events(%{aggregate | active: false}, %DisableUser{user_id: user_id}, [])
    end
  end

  describe "EnableUser" do
    test "should emit UserEnabled if user is disabled" do
      %{id: user_id} = aggregate = build(:user_aggregate)

      assert_events(
        %{aggregate | active: false},
        %EnableUser{user_id: user_id},
        [%UserEnabled{user_id: user_id}]
      )
    end

    test "should not emit any event if user is not disabled" do
      %{id: user_id} = aggregate = build(:user_aggregate)

      assert_events(aggregate, %EnableUser{user_id: user_id}, [])
    end
  end

  describe "UpdateUser" do
    test "should emit UserEmailChanged and UserPasswordChanged" do
      %{id: id} = aggregate = build(:user_aggregate)
      params = build(:user)
      params = Map.put(params, :hashed_password, params.password)

      assert_events(
        aggregate,
        struct(UpdateUser, params),
        [
          %UserPasswordChanged{user_id: id, password: params.password},
          %UserEmailChanged{user_id: id, email: params.email}
        ]
      )
    end
  end
end
