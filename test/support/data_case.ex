defmodule ExpenseTracker.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ExpenseTracker.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias ExpenseTracker.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import ExpenseTracker.Factory
      import ExpenseTracker.Fixture
      import ExpenseTracker.DataCase
      import ExpenseTracker.Helpers.Wait
      import ExpenseTracker.Helpers.ProcessHelper
    end
  end

  setup do
    ExpenseTracker.Storage.reset!()
  end
end
