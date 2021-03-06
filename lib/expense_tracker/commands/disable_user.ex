defmodule ExpenseTracker.Commands.DisableUser do
  @moduledoc false

  defstruct [:user_id]
end

defimpl ExpenseTracker.Protocol.ValidCommand, for: ExpenseTracker.Commands.DisableUser do
  alias ExpenseTracker.Validators.Uuid

  def validate(%{user_id: user_id} = _command) do
    user_id
    |> Uuid.validate()
    |> case do
      :ok -> :ok
      {:error, err} -> [{:user_id, err}]
    end
  end
end
