defmodule ExpenseTracker.Web.Plugs.LoadCurrentUser do
  @moduledoc false

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    with user_map <- get_session(conn, :user),
         true <- is_binary(user_map),
         user <- Jason.decode!(user_map) do
      assign(conn, :current_user, user)
    else
      _ -> conn
    end
  end
end
