defmodule DebtmanagerWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use DebtmanagerWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import DebtmanagerWeb.ConnCase

      alias DebtmanagerWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint DebtmanagerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Debtmanager.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Debtmanager.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  setup %{conn: conn} do
    user = %Debtmanager.Users.User{email: "qaz1@gmail.com", id: 1}
    authed_conn = Pow.Plug.assign_current_user(conn, user, otp_app: :my_app)

    {:ok, conn: conn, authed_conn: authed_conn}
  end
end
