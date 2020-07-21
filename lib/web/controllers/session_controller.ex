defmodule ExpenseTracker.Web.SessionController do
  use ExpenseTracker.Web, :controller

  def signin(%{assigns: %{current_user: %{}}} = conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))

  def signin(conn, _) do
    render conn, "signin.html", path: Routes.session_path(conn, :create_session), page_title: "Sign in"
  end

  def signup(%{assigns: %{current_user: %{}}} = conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))

  def signup(conn, _) do
    render conn, "signup.html", path: Routes.session_path(conn, :create_account), page_title: "Sign up"
  end

  def create_account(conn, %{"email" => email, "password" => pass}) do
    with {:ok, _account} <- ExpenseTracker.Accounts.create_user(%{email: email, password: pass}),
         {:ok, conn} <- ExpenseTracker.Web.Support.Auth.auth_with_email_and_password(conn, email, pass) do
      redirect(conn, to: Routes.page_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, "Could not create account")
        |> redirect(to: Routes.session_path(conn, :signin))
    end
  end

  def create_session(conn, %{"email" => email, "password" => pass}) do
    case ExpenseTracker.Web.Support.Auth.auth_with_email_and_password(conn, email, pass) do
      {:ok, conn} -> redirect(conn, to: Routes.page_path(conn, :index))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password")
        |> redirect(to: Routes.session_path(conn, :signin))
    end
  end

  def delete_session(conn, _) do
    conn
    |> clear_session
    |> redirect(to: Routes.session_path(conn, :signin))
  end
end
