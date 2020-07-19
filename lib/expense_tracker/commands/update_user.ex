defmodule ExpenseTracker.Commands.UpdateUser do
  defstruct [:user_id, :email, :password, :hashed_password]

  alias ExpenseTracker.Support.Auth

  def assign_user(%__MODULE__{} = command, %{id: id}) do
    %__MODULE__{command | user_id: id}
  end

  def downcase_email(%__MODULE__{email: email} = command) do
    case is_binary(email) do
      false -> command
      true ->  %__MODULE__{command | email: String.downcase(email)}
    end
  end

  def hash_password(%__MODULE__{password: ""} = command), do: command

  def hash_password(%__MODULE__{password: nil} = command), do: command

  def hash_password(%__MODULE__{password: password} = command) do
    %__MODULE__{command |
      password: nil,
      hashed_password: Auth.hash_password(password),
    }
  end
end

defimpl ExpenseTracker.Protocol.UniqueFields, for: ExpenseTracker.Commands.UpdateUser do
  alias ExpenseTracker.Validators.Email

  def unique(%{email: nil} = _command), do: :ok

  def unique(%{user_id: user_id, email: email} = _command) do
    case validate_email(email, user_id) do
      :ok -> :ok
      err -> {:error, Keyword.new([err])}
    end
  end

  defp validate_email(email, user_id) do
    case Email.user_email_taken?(email, user_id) do
      false -> :ok
      true  -> {:email, "has been taken"}
    end
  end
end

defimpl ExpenseTracker.Protocol.ValidCommand, for: ExpenseTracker.Commands.UpdateUser do
  alias ExpenseTracker.Validators.{StringValidator, Uuid, Email}

  def validate(%{user_id: user_id} = command) do
    user_id
    |> validate_user_id
    |> Kernel.++(validate_hashed_password(command.hashed_password))
    |> Kernel.++(validate_email(command.email))
    |> case do
      []       -> :ok
      err_list -> {:error, err_list}
    end
  end

  defp validate_user_id(user_id) do
    case Uuid.validate(user_id) do
      :ok           -> []
      {:error, err} -> [{:user_id, err}]
    end
  end

  defp validate_email(""), do: [{:email, "is empty"}]

  defp validate_email(nil), do: []

  defp validate_email(email) do
    case Email.validate(email) do
      :ok           -> []
      {:error, err} -> [{:email, err}]
    end
  end

  defp validate_hashed_password(""), do: []

  defp validate_hashed_password(nil), do: []

  defp validate_hashed_password(hashed_password) do
    case StringValidator.validate(hashed_password) do
      :ok           -> []
      {:error, err} -> [{:hashed_password, err}]
    end
  end
end
