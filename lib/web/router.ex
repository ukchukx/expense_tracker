defmodule ExpenseTracker.Web.Router do
  use ExpenseTracker.Web, :router

  forward "/health/live", Healthchex.Probes.Liveness
  forward "/health/ready", Healthchex.Probes.Readiness

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth, do: plug ExpenseTracker.Web.Plugs.LoadCurrentUser

  # Other scopes may use custom stacks.
  scope "/api", ExpenseTracker.Web do
    pipe_through [:api, :fetch_session, :auth]

    post "/budgets", PageController, :create_budget
    post "/expenses", PageController, :create_expense
    delete "/expenses/:id", PageController, :delete_expense
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: ExpenseTracker.Web.Telemetry
    end
  end

  scope "/", ExpenseTracker.Web do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/account", PageController, :account
    get "/budgets", PageController, :budgets
    get "/budgets/:b", PageController, :budget_details
    get "/l/:b/:i", PageController, :line_item

    get "/signup", SessionController, :signup
    post "/signup", SessionController, :create_account
    get "/signin", SessionController, :signin
    post "/signin", SessionController, :create_session
    get "/signout", SessionController, :delete_session

    get "/*path", PageController, :catch_all
  end
end
