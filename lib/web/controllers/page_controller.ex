defmodule ExpenseTracker.Web.PageController do
  alias ExpenseTracker.Budgets

  use ExpenseTracker.Web, :controller

  require Logger

  def index(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    {current_budget, previous_budget, title} =
      user_id
      |> Budgets.budgets_for_user()
      |> Budgets.calculate_line_item_expensed_values_for_budgets()
      |> case do
        [] ->
          {nil, nil, "Home"}

        [latest_budget = %{line_items: items, id: id, name: name} | other_budgets] ->
          case Budgets.current_budget?(latest_budget) do
            true ->
              items =
                Enum.map(items, fn item ->
                  Map.put(item, "href", Routes.page_path(conn, :line_item, id, item["id"]))
                end)

              {%{latest_budget | line_items: items}, List.first(other_budgets), name}

            false ->
              {nil, latest_budget, "Home"}
          end
      end

    render(conn, "index.html",
      user: user,
      previous_budget: previous_budget,
      current_budget: current_budget,
      page_title: title
    )
  end

  def index(conn, _), do: redirect(conn, to: Routes.session_path(conn, :signin))

  def create_budget(%{assigns: %{current_user: %{"id" => user_id}}} = conn, params) do
    context = %{user: %{id: user_id}}

    %{"start_date" => s, "end_date" => e} = params

    params =
      params
      |> Map.put("start_date", Date.from_iso8601!(s))
      |> Map.put("end_date", Date.from_iso8601!(e))

    with {:ok, budget} <-
           params |> AtomizeKeys.atomize_string_keys() |> Budgets.create_budget(context) do
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
    render(conn, "account.html", user: user, page_title: "Account")
  end

  def budgets(%{assigns: %{current_user: %{"id" => user_id} = user}} = conn, _) do
    budgets =
      user_id
      |> Budgets.budgets_for_user()
      |> Budgets.calculate_line_item_expensed_values_for_budgets()
      |> Enum.map(fn budget = %{line_items: items, id: id} ->
        current? = Budgets.current_budget?(budget)

        href =
          case current? do
            false -> Routes.page_path(conn, :budget_details, budget.id)
            true -> "#"
          end

        items =
          case current? do
            false ->
              Enum.map(items, fn item ->
                Map.put(item, "href", Routes.page_path(conn, :line_item, id, item["id"]))
              end)

            true ->
              items
          end

        %{budget | href: href, line_items: items}
      end)

    render(conn, "budgets.html", user: user, budgets: budgets, page_title: "Budgets")
  end

  def budget_details(%{assigns: %{current_user: %{} = user}} = conn, %{"b" => id}) do
    {:ok, budget} = Budgets.budget_by_id(id)

    case Budgets.current_budget?(budget) do
      true ->
        redirect(conn, to: Routes.page_path(conn, :budgets))

      false ->
        budget = %{name: name} = Budgets.calculate_line_item_expensed_values_for_budget(budget)

        render(conn, "budget_details.html",
          user: user,
          budget: budget,
          page_title: "Budget - #{name}"
        )
    end
  end

  def line_item(%{assigns: %{current_user: %{} = u}} = conn, %{"b" => id, "i" => item_id}) do
    {:ok, %{line_items: items}} = Budgets.budget_by_id(id)
    %{"description" => d} = item = Enum.find(items, &(&1["id"] == item_id))
    expense_items = Budgets.expense_items_for_line_item(item_id)

    render(conn, "line_item.html",
      user: u,
      budget_id: id,
      item: item,
      expense_items: expense_items,
      page_title: "#{d}"
    )
  end

  def create_expense(
        %{assigns: %{current_user: %{"id" => user_id}}} = conn,
        %{"budget_id" => b_id, "line_item_id" => item_id} = params
      ) do
    with {:ok, %{user_id: ^user_id, line_items: items}} <- Budgets.budget_by_id(b_id),
         true <- Enum.any?(items, &(&1["id"] == item_id)),
         today_date <- Date.utc_today() |> Date.to_string(),
         params =
           params
           |> Map.take(["amount", "description", "date"])
           |> Map.put_new("date", today_date)
           |> AtomizeKeys.atomize_string_keys(),
         {:ok, expense} <-
           Budgets.create_expense_item(params, %{budget: %{id: b_id}, line_item: %{id: item_id}}) do
      conn
      |> Plug.Conn.put_status(201)
      |> json(%{data: expense})
    else
      err ->
        Logger.error("Could not create expense item due to #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(500)
        |> json(%{error: "Could not create expense"})
    end
  end

  def delete_expense(%{assigns: %{current_user: %{"id" => user_id}}} = conn, %{"id" => id}) do
    with {:ok, %{user_id: ^user_id} = e} <- Budgets.expense_item_by_id(id),
         :ok <- Budgets.delete_expense_item(e) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(204, "")
    else
      err ->
        Logger.error("Could not delete expense item #{id} due to #{inspect(err)}")

        conn
        |> Plug.Conn.put_status(500)
        |> json(%{error: "Could not delete expense"})
    end
  end

  def catch_all(conn, _), do: redirect(conn, to: Routes.page_path(conn, :index))
end
