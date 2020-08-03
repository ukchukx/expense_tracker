defmodule ExpenseTracker.Web.PageController do
  alias ExpenseTracker.Budgets

  use ExpenseTracker.Web, :controller

  require Logger

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    {current_budget, other_budgets} =
      user_id
      |> Budgets.budgets_for_user
      |> Budgets.calculate_line_item_expensed_values_for_budgets
      |> case do
        [] -> {nil, []}
        [latest_budget | other_budgets] = budgets ->
          case Budgets.current_budget?(latest_budget) do
            true -> {latest_budget, other_budgets}
            false -> {nil, budgets}
          end
      end

    render conn, "index.html", user: user, budgets: other_budgets, current_budget: current_budget, page_title: "Home"
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def create_budget(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    context = %{user: %{id: user_id}}

    %{"start_date" => s, "end_date" => e} = params
    params =
      params
      |> Map.put("start_date", Date.from_iso8601!(s))
      |> Map.put("end_date", Date.from_iso8601!(e))

    with {:ok, budget} <- params |> AtomizeKeys.atomize_string_keys |> Budgets.create_budget(context) do
      conn
      |> Plug.Conn.put_status(201)
      |> json(%{data: budget})
    else
      {:error, err} ->
        Logger.error("Error while creating budget #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(400)
        |> json(%{error: "Could not create budget"})
    end
  end

  def account(%{assigns: %{current_user: %{"id" => _} = user}} = conn, _) do
    render conn, "account.html", user: user, page_title: "Account"
  end

  def budgets(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    budgets =
      user_id
      |> Budgets.budgets_for_user
      |> Budgets.calculate_line_item_expensed_values_for_budgets
      |> Enum.map(fn budget ->
        href =
          case Budgets.current_budget?(budget) do
            false -> Routes.page_path(conn, :budget_details, budget.id)
            true -> "#"
          end

        %{budget | href: href}
      end)

    render conn, "budgets.html", user: user, budgets: budgets, page_title: "Budgets"
  end

  def budget_details(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, %{"b" => id}) do
    {:ok, budget} = Budgets.budget_by_id(id)

    case Budgets.current_budget?(budget) do
      true ->
        redirect(conn, to: Routes.page_path(conn, :budgets))
      false ->
        budget = %{name: name} = Budgets.calculate_line_item_expensed_values_for_budget(budget)
        render conn, "budget_details.html", user: user, budget: budget, page_title: "Budget - #{name}"
    end
  end

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))
end
