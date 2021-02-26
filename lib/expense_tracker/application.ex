defmodule ExpenseTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Confex.resolve_env!(:expense_tracker)

    children = [
      ExpenseTracker.CommandedApp,
      # Start the Ecto repository
      ExpenseTracker.Repo,
      ExpenseTracker.CommandedSupervisor,
      # Start the Telemetry supervisor
      ExpenseTracker.Web.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ExpenseTracker.PubSub},
      # Start the Endpoint (http/https)
      ExpenseTracker.Web.Endpoint
      # Start a worker by calling: ExpenseTracker.Worker.start_link(arg)
      # {ExpenseTracker.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExpenseTracker.Supervisor]

    case Supervisor.start_link(children, opts) do
      {:ok, _} = res ->
        ExpenseTracker.TelemetryReporter.setup()

        if Application.get_env(:expense_tracker, :env) != :test do
          ExpenseTracker.Support.SetupDatabase.run()
        end

        res

      err_res ->
        err_res
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ExpenseTracker.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
