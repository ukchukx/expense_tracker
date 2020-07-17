defmodule ExpenseTracker.Web.PageController do
  use ExpenseTracker.Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
