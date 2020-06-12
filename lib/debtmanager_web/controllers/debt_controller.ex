defmodule DebtmanagerWeb.DebtController do
  use DebtmanagerWeb, :controller

  alias Debtmanager.Debts
  alias Debtmanager.Debts.Debt

  def index(conn, _params) do
    debts = Debts.list_debts()
    render(conn, "index.html", debts: debts)
  end

  def new(conn, _params) do
    changeset = Debts.change_debt(%Debt{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"debt" => debt_params}) do
    case Debts.create_debt(debt_params) do
      {:ok, debt} ->
        conn
        |> put_flash(:info, "Debt created successfully.")
        |> redirect(to: Routes.debt_path(conn, :show, debt))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    debt = Debts.get_debt!(id)
    render(conn, "show.html", debt: debt)
  end

  def edit(conn, %{"id" => id}) do
    debt = Debts.get_debt!(id)
    changeset = Debts.change_debt(debt)
    render(conn, "edit.html", debt: debt, changeset: changeset)
  end

  def update(conn, %{"id" => id, "debt" => debt_params}) do
    debt = Debts.get_debt!(id)

    case Debts.update_debt(debt, debt_params) do
      {:ok, debt} ->
        conn
        |> put_flash(:info, "Debt updated successfully.")
        |> redirect(to: Routes.debt_path(conn, :show, debt))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", debt: debt, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    debt = Debts.get_debt!(id)
    {:ok, _debt} = Debts.delete_debt(debt)

    conn
    |> put_flash(:info, "Debt deleted successfully.")
    |> redirect(to: Routes.debt_path(conn, :index))
  end
end
