defmodule ExpenseTracker.Projections.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :user_id,
    :name,
    :start_date,
    :end_date,
    :line_items,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "budgets" do
    field :user_id, :binary_id
    field :name, :string
    field :start_date, :date
    field :end_date, :date
    field :line_items, {:array, :map}, default: []

    timestamps(type: :utc_datetime)
  end

  def changeset(params), do: changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = module, params), do: cast(module, params, @fields)
end
