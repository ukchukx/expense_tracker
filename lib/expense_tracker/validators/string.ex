defmodule ExpenseTracker.Validators.StringValidator do

  def validate(value) do
    case String.valid?(value) do
      true  -> :ok
      false -> {:error, "is not a valid string"}
    end
  end

end
