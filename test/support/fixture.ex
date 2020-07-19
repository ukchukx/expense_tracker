defmodule ExpenseTracker.Fixture do
  alias ExpenseTracker.Accounts

  def fixture(resource, attrs \\ [])

  def fixture(:user, attrs), do: create_user(attrs)

  defp create_user(attrs \\ []), do: attrs |> ExpenseTracker.Factory.build_user_params |> Accounts.create_user

  def user_context do
    {:ok, user}  = create_user()

    user_context(user)
  end

  def user_context(%{} = user), do: %{user: user}
end
