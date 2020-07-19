defmodule ExpenseTracker.Projections.ExpenseItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :user_id,
    :budget_id,
    :description,
    :amount,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "expense_items" do
    field :user_id, :binary_id
    field :budget_id, :binary_id
    field :description, :string
    field :amount, :integer

    timestamps(type: :utc_datetime)
  end

  def changeset(params), do: changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = module, params), do: cast(module, params, @fields)
end
