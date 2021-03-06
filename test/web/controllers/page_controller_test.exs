defmodule ExpenseTracker.Web.PageControllerTest do
  use ExpenseTracker.Web.ConnCase

  @moduletag :pending

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
