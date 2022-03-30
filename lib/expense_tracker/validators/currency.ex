defmodule ExpenseTracker.Validators.Currency do
  @moduledoc false

  alias ExpenseTracker.Support.Currency

  def validate(currency) when is_binary(currency) do
    case currency in Currency.supported_currencies() do
      true -> :ok
      false -> {:error, :not_supported}
    end

  end
  def validate(_), do: {:error, :not_supported}
end
