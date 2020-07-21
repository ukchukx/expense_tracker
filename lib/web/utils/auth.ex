defmodule ExpenseTracker.Web.Support.Auth do
  import Plug.Conn

  def auth_with_email_and_password(conn, email, pass) do
    case ExpenseTracker.Accounts.user_by_email(email) do
      {:ok, %{active: true} = user} ->
        cond do
          ExpenseTracker.Support.Auth.validate_password(pass, user.password) -> {:ok, set_session(conn, user)}
          user -> {:error, :unauthorized, conn}
        end

      _ ->
        Bcrypt.no_user_verify()
        {:error, :inactive, conn}
    end
  end

  def set_session(conn, %{} = user) do
    attrs = Map.take(user, [:id, :email])

    conn
    |> assign(:current_user, attrs)
    |> put_session(:user, Jason.encode!(attrs))
    |> configure_session(renew: true)
  end
end
