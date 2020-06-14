defmodule Debtmanager.DebtsTest do
  use Debtmanager.DataCase

  alias Debtmanager.Debts

  describe "debts" do
    alias Debtmanager.Debts.Debt

    @valid_attrs %{creator: 1, debtor: 2, reminder: true, value: 42, paid: false}
    @update_attrs %{creator: 1, debtor: 2, reminder: false, value: 43, paid: true}
    @invalid_attrs %{creator: 1, debtor: 2, reminder: false, value: "sdfsd", paid: true}

    def debt_fixture(attrs \\ %{}) do
      {:ok, debt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Debts.create_debt()

      debt
    end

    test "list_debts/0 returns all debts" do
      debt = debt_fixture()
      assert Debts.list_debts() == [debt]
    end

    test "get_debt!/1 returns the debt with given id" do
      debt = debt_fixture()
      assert Debts.get_debt!(debt.id) == debt
    end

    test "create_debt/1 with valid data creates a debt" do
      assert {:ok, %Debt{} = debt} = Debts.create_debt(@valid_attrs)
      assert debt.creator == 1
      assert debt.debtor == 2
      assert debt.reminder == true
      assert debt.value == 42
    end

    test "create_debt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Debts.create_debt(@invalid_attrs)
    end

    test "update_debt/2 with valid data updates the debt" do
      debt = debt_fixture()
      assert {:ok, %Debt{} = debt} = Debts.update_debt(debt, @update_attrs)
      assert debt.creator == 1
      assert debt.debtor == 2
      assert debt.reminder == false
      assert debt.value == 43
    end

    test "update_debt/2 with invalid data returns error changeset" do
      debt = debt_fixture()
      assert {:error, %Ecto.Changeset{}} = Debts.update_debt(debt, @invalid_attrs)
      assert debt == Debts.get_debt!(debt.id)
    end

    test "delete_debt/1 deletes the debt" do
      debt = debt_fixture()
      assert {:ok, %Debt{}} = Debts.delete_debt(debt)
      assert_raise Ecto.NoResultsError, fn -> Debts.get_debt!(debt.id) end
    end

    test "change_debt/1 returns a debt changeset" do
      debt = debt_fixture()
      assert %Ecto.Changeset{} = Debts.change_debt(debt)
    end

  end
end
