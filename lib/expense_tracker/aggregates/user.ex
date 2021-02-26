defmodule ExpenseTracker.Aggregates.User do
  @moduledoc false

  defstruct [:id, :active, :email, :password]

  alias ExpenseTracker.Commands.{
    CreateUser,
    DisableUser,
    EnableUser,
    UpdateUser
  }

  alias ExpenseTracker.Events.{
    UserCreated,
    UserDisabled,
    UserEmailChanged,
    UserEnabled,
    UserPasswordChanged
  }

  @behaviour Commanded.Aggregates.AggregateLifespan

  def execute(%__MODULE__{}, %CreateUser{} = command) do
    %UserCreated{
      user_id: command.user_id,
      email: command.email,
      active: command.active,
      password: command.hashed_password
    }
  end

  def execute(%__MODULE__{active: false}, %EnableUser{user_id: id}), do: %UserEnabled{user_id: id}
  def execute(%__MODULE__{active: true}, %EnableUser{}), do: []

  def execute(%__MODULE__{active: true}, %DisableUser{user_id: id}),
    do: %UserDisabled{user_id: id}

  def execute(%__MODULE__{active: false}, %DisableUser{}), do: []

  def execute(%__MODULE__{} = user, %UpdateUser{} = command) do
    [&email_changed/2, &password_changed/2]
    |> Enum.reduce([], fn action, events ->
      case action.(user, command) do
        nil -> events
        event -> [event | events]
      end
    end)
  end

  def after_event(%UserDisabled{}), do: :hibernate
  def after_event(_), do: :infinity

  def after_command(_command), do: :infinity
  def after_error(_error), do: :stop

  def apply(%__MODULE__{} = user, %UserCreated{} = e) do
    %__MODULE__{user | id: e.user_id, email: e.email, active: e.active, password: e.password}
  end

  def apply(%__MODULE__{} = user, %UserEmailChanged{email: email}) do
    %__MODULE__{user | email: email}
  end

  def apply(%__MODULE__{} = user, %UserPasswordChanged{password: p}) do
    %__MODULE__{user | password: p}
  end

  def apply(%__MODULE__{} = user, %UserDisabled{}) do
    %__MODULE__{user | active: false}
  end

  def apply(%__MODULE__{} = user, %UserEnabled{}) do
    %__MODULE__{user | active: true}
  end

  defp email_changed(%__MODULE__{}, %UpdateUser{email: e}) when e == "" or is_nil(e), do: nil
  defp email_changed(%__MODULE__{email: email}, %UpdateUser{email: email}), do: nil

  defp email_changed(%__MODULE__{id: id}, %UpdateUser{email: email}) do
    %UserEmailChanged{user_id: id, email: email}
  end

  defp password_changed(%__MODULE__{}, %UpdateUser{hashed_password: h}) when h == "" or is_nil(h),
    do: nil

  defp password_changed(%__MODULE__{id: id}, %UpdateUser{hashed_password: p}) do
    %UserPasswordChanged{user_id: id, password: p}
  end
end
