defmodule ExpenseTracker.Web.PageController do
  alias ExpenseTracker.Budgets

  use ExpenseTracker.Web, :controller

  require Logger

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    budgets = Budgets.budgets_for_user(user_id)

    render conn, "index.html", user: user, budgets: budgets, page_title: "Home"
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))
end
