defmodule ExpenseTracker.Validators.Email do
  alias ExpenseTracker.Accounts

  @email_regex ~r/\S+@\S+\.\S+/

  def validate(email) when is_binary(email) do
    case String.match?(email, @email_regex) do
      false -> {:error, "is not an email address"}
      true -> :ok
    end
  end

  def validate(_), do: {:error, "is not a string"}

  def user_email_taken?(email, user_id) do
    with {:ok, %{user_id: ^user_id}} <- Accounts.user_by_email(email) do
      false
    else
      {:error, :not_found} -> false
      {:ok, _} -> true
    end
  end
end
