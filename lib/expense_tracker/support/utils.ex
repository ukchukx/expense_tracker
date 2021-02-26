defmodule ExpenseTracker.Support.Utils do
  @moduledoc false

  @month_names %{
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
  }

  def to_map(struct) when is_struct(struct),
    do: struct |> Map.from_struct() |> Map.drop([:__struct__, :__meta__])

  def to_map(others), do: others

  def budget_name(%{year: y, month: m}), do: "#{@month_names[m]}, #{y}"
end
