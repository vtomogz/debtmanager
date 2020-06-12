defmodule Debtmanager.DebtsTest do
  use Debtmanager.DataCase

  alias Debtmanager.Debts

  describe "debts" do
    alias Debtmanager.Debts.Debt

    @valid_attrs %{creator: "some creator", debtor: "some debtor", reminder: true, value: 42}
    @update_attrs %{creator: "some updated creator", debtor: "some updated debtor", reminder: false, value: 43}
    @invalid_attrs %{creator: nil, debtor: nil, reminder: nil, value: nil}

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
      assert debt.creator == "some creator"
      assert debt.debtor == "some debtor"
      assert debt.reminder == true
      assert debt.value == 42
    end

    test "create_debt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Debts.create_debt(@invalid_attrs)
    end

    test "update_debt/2 with valid data updates the debt" do
      debt = debt_fixture()
      assert {:ok, %Debt{} = debt} = Debts.update_debt(debt, @update_attrs)
      assert debt.creator == "some updated creator"
      assert debt.debtor == "some updated debtor"
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
