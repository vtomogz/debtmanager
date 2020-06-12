defmodule DebtmanagerWeb.DebtControllerTest do
  use DebtmanagerWeb.ConnCase

  alias Debtmanager.Debts

  @create_attrs %{creator: "some creator", debtor: "some debtor", reminder: true, value: 42}
  @update_attrs %{creator: "some updated creator", debtor: "some updated debtor", reminder: false, value: 43}
  @invalid_attrs %{creator: nil, debtor: nil, reminder: nil, value: nil}

  def fixture(:debt) do
    {:ok, debt} = Debts.create_debt(@create_attrs)
    debt
  end

  describe "index" do
    test "lists all debts", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.debt_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "Listing Debts"
    end
  end

  describe "new debt" do
    test "renders form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.debt_path(authed_conn, :new))
      assert html_response(conn, 200) =~ "New Debt"
    end
  end

  describe "create debt" do
    test "redirects to show when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.debt_path(authed_conn, :create), debt: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.debt_path(conn, :show, id)

      conn = get(authed_conn, Routes.debt_path(authed_conn, :show, id))
      assert html_response(conn, 200) =~ "Show Debt"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.debt_path(authed_conn, :create), debt: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Debt"
    end
  end

  describe "edit debt" do
    setup [:create_debt]

    test "renders form for editing chosen debt", %{authed_conn: authed_conn, debt: debt} do
      conn = get(authed_conn, Routes.debt_path(authed_conn, :edit, debt))
      assert html_response(conn, 200) =~ "Edit Debt"
    end
  end

  describe "update debt" do
    setup [:create_debt]

    test "redirects when data is valid", %{authed_conn: authed_conn, debt: debt} do
      conn = put(authed_conn, Routes.debt_path(authed_conn, :update, debt), debt: @update_attrs)
      assert redirected_to(conn) == Routes.debt_path(conn, :show, debt)

      conn = get(authed_conn, Routes.debt_path(authed_conn, :show, debt))
      assert html_response(conn, 200) =~ "some updated creator"
    end

    test "renders errors when data is invalid", %{authed_conn: authed_conn, debt: debt} do
      conn = put(authed_conn, Routes.debt_path(authed_conn, :update, debt), debt: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Debt"
    end
  end

  describe "delete debt" do
    setup [:create_debt]

    test "deletes chosen debt", %{authed_conn: authed_conn, debt: debt} do
      conn = delete(authed_conn, Routes.debt_path(authed_conn, :delete, debt))
      assert redirected_to(conn) == Routes.debt_path(conn, :index)
      assert_error_sent 404, fn ->
        get(authed_conn, Routes.debt_path(authed_conn, :show, debt))
      end
    end
  end

  defp create_debt(_) do
    debt = fixture(:debt)
    %{debt: debt}
  end
end
