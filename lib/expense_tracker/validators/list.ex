defmodule ExpenseTracker.Validators.ListValidator do

  def validate_list_of_string(value) do
    case Enum.all?(value, &String.valid?/1) do
      true  -> :ok
      false -> {:error, "is not a valid list of strings"}
    end
  end

end
