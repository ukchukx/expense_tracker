defmodule ExpenseTracker.Validators.Uuid do

  def validate(uuid) do
    case Ecto.UUID.cast(uuid) do
      {:ok, _} -> :ok
      _        -> {:error, "is invalid"}
    end
  end

end
