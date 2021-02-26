defmodule ExpenseTracker.Projections.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @fields [
    :id,
    :email,
    :active,
    :inserted_at,
    :updated_at
  ]

  @derive {Jason.Encoder, only: @fields}

  schema "users" do
    field :password, :string
    field :email, :string, unique: true
    field :active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  def changeset(params), do: changeset(%__MODULE__{}, params)

  def changeset(%__MODULE__{} = module, params), do: cast(module, params, @fields)
end
