defmodule ExpenseTracker.UserTest do
  alias ExpenseTracker.{Accounts, DataCase}
  alias ExpenseTracker.Projections.User

  use DataCase

  @moduletag models: :user
  @moduletag :user

  describe "a user" do
    test "can be created" do
      assert {:ok, %User{id: user_id}} = fixture(:user)
      assert {:ok, _} = Accounts.user_by_id(user_id)
    end

    test "can be updated" do
      assert {:ok, %User{} = user} = fixture(:user)

      params = build_user_params() |> Map.take([:email, :password])

      assert {:ok, %User{} = updated_user} = Accounts.update_user(user, params)

      # Unchanged
      assert user.id == updated_user.id
      assert user.active == updated_user.active
      # Changed
      assert updated_user.email == params.email
      refute updated_user.password == user.password
    end

    test "can be disabled" do
      assert {:ok, %User{id: user_id} = user} = fixture(:user)
      assert {:ok, %User{active: false, id: ^user_id}} = Accounts.disable_user(user)
    end

    test "cannot be disabled if already disabled" do
      assert {:ok, %User{} = user} = fixture(:user)
      assert {:ok, %User{} = disabled_user} = Accounts.disable_user(user)
      assert {:error, :already_disabled} = Accounts.disable_user(disabled_user)
    end

    test "can be enabled" do
      assert {:ok, %User{id: user_id} = user} = fixture(:user)
      assert {:ok, %User{} = disabled_user} = Accounts.disable_user(user)
      assert {:ok, %User{active: true, id: ^user_id}} = Accounts.enable_user(disabled_user)
    end

    test "cannot be enabled if already enabled" do
      assert {:ok, %User{} = user} = fixture(:user)
      assert {:error, :already_enabled} = Accounts.enable_user(user)
    end
  end
end
