defmodule ExpenseTracker.Support.Utils do
	def to_map(struct) when is_struct(struct), do: struct |> Map.from_struct |> Map.drop([:__struct__, :__meta__])

	def to_map(others), do: others
end
