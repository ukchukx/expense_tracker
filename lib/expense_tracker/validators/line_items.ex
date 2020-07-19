defmodule ExpenseTracker.Validators.LineItemsValidator do

  def validate(value) do
    case Enum.all?(value, &validate_line_item/1) do
      true  -> :ok
      false -> {:error, "is not a valid list of line items (which should have amount and description)"}
    end
  end

  def validate_line_item(%{amount: a, description: d}) when is_integer(a) and is_binary(d), do: true

  def validate_line_item(_), do: false

end
