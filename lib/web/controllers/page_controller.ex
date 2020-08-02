defmodule ExpenseTracker.Web.PageController do
  alias ExpenseTracker.Budgets

  use ExpenseTracker.Web, :controller

  require Logger

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    {current_budget, other_budgets} =
      case Budgets.budgets_for_user(user_id) do
        [] -> {nil, []}
        [latest_budget | other_budgets] = budgets ->
          today = Date.utc_today()

          case today.year == latest_budget.year and today.month == latest_budget.month do
            true -> {latest_budget, other_budgets}
            false -> {nil, budgets}
          end
      end

    render conn, "index.html", user: user, budgets: other_budgets, current_budget: current_budget, page_title: "Home"
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def create_budget(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    context = %{user: %{id: user_id}}

    conn
      |> Plug.Conn.put_status(201)
      |> json(%{data: Map.put(params, "user_id", user_id) |> Map.put("id", user_id)})

    # with {:ok, budget} <- params |> AtomizeKeys.atomize_string_keys |> Budgets.create_budget(context) do
    #   conn
    #   |> Plug.Conn.put_status(201)
    #   |> json(%{data: budget})
    # else
    #   {:error, err} ->
    #     Logger.error("Error while creating budget #{inspect(err)}")

    #     conn
    #     |> Plug.Conn.put_status(400)
    #     |> json(%{error: "Could not create budget"})
    # end
  end

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))
end
