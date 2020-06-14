defmodule DebtmanagerWeb.DebtControllerTest do
  use DebtmanagerWeb.ConnCase

  alias Debtmanager.Debts

  @create_attrs %{creator: 1, debtor: 2, reminder: true, value: 42, paid: false}
  @update_attrs %{creator: 1, debtor: 2, reminder: false, value: 43, paid: true}
  @invalid_attrs %{creator: 1, debtor: 1, reminder: false, value: "sad", paid: "asd"}

  def fixture(:debt) do
    {:ok, debt} = Debts.create_debt(@create_attrs)
    debt
  end

  describe "index" do
    test "lists my debts", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.debt_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Debts"
    end
  end

  describe "new debt" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.debt_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "Create new Loan"
    end
  end

  describe "create debt" do
    test "redirects to index when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.debt_path(authed_conn, :create), debt: @create_attrs)

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == Routes.debt_path(conn, :index)

      conn = get(authed_conn, Routes.debt_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Debts"
    end

    test "redirects to new and render error", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.debt_path(authed_conn, :create), debt: @invalid_attrs)

      assert %{} = redirected_params(conn)
      assert redirected_to(conn) == Routes.debt_path(conn, :new)

      conn = get(authed_conn, Routes.debt_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "Create new Loan"
    end
  end

  
end
