defprotocol ExpenseTracker.Protocol.UniqueFields do
  @fallback_to_any true

  def unique(command)
end

defimpl ExpenseTracker.Protocol.UniqueFields, for: Any do
  def unique(_command), do: :ok
end
