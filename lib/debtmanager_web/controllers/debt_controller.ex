defmodule DebtmanagerWeb.DebtController do
  use DebtmanagerWeb, :controller

  alias Debtmanager.Debts
  alias Debtmanager.Debts.Debt
  alias Debtmanager.Friendships

  def overview(conn, _parmas) do
    case conn.assigns.current_user do
      nil ->
        render(conn, "overview.html")
      _ ->
        debts_info = Debts.get_debts_info(conn.assigns.current_user.id)
        charges_info = Debts.get_charges_info(conn.assigns.current_user.id)
        reminders = Debts.get_reminders(conn.assigns.current_user.id)
        render(conn, "overview.html", debts: debts_info, charges: charges_info, reminders: reminders )
    end
  end

  def index(conn, _params) do
    debts = Debts.list_my_debts(conn.assigns.current_user.id) |> Enum.chunk_every(3,3,[nil,nil,nil])
    charges = Debts.list_my_charges(conn.assigns.current_user.id) |> Enum.chunk_every(3,3,[nil,nil,nil])
    render(conn, "index.html", debts: debts, charges: charges)
  end

  def new(conn, _params) do
    friends = Friendships.list_my_friends(conn.assigns.current_user.email) |> Enum.map(&{"#{&1.name} #{&1.surname}, #{&1.email}", &1.id})
    changeset = Debts.change_debt(%Debt{creator: conn.assigns.current_user.id, reminder: false})
    render(conn, "new.html", changeset: changeset, friends: friends)
  end

  def create(conn, %{"debt" => debt_params}) do
    case Debts.add_debt(conn.assigns.current_user.id, debt_params) do
      {:ok, _debt} ->
        conn
        |> put_flash(:info, "Loan created succesfully.")
        |> redirect(to: Routes.debt_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        [value: {message, _tail}] = changeset.errors
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.debt_path(conn, :new))
    end
  end

  def remind(conn, %{"id" => id}) do
    debt = Debts.get_debt!(id)

    case Debts.remind(debt) do
      {:ok, _debt} ->
        conn
        |> put_flash(:info, "Debtor has been urged.")
        |> redirect(to: Routes.debt_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Error occured.")
        |> redirect(to: Routes.debt_path(conn, :index))
    end
  end

  def pay(conn, %{"id" => id}) do
    debt = Debts.get_debt!(id)

    case Debts.pay(debt) do
      {:ok, _debt} ->
        conn
        |> put_flash(:info, "Debt marked as a paid.")
        |> redirect(to: Routes.debt_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:info, "Error occured.")
        |> redirect(to: Routes.debt_path(conn, :index))
    end
  end

  def history(conn, params) do
    if params != %{} do
      friends = Friendships.list_my_friends(conn.assigns.current_user.email) |> Enum.map(&{"#{&1.name} #{&1.surname}, #{&1.email}", &1.id})
      changeset = Debts.change_debt(%Debt{creator: conn.assigns.current_user.id})
      %{"id" => id} = params
      old_debts = Debts.get_old_debts(id, conn.assigns.current_user.id)
      old_charges = Debts.get_old_charges(id, conn.assigns.current_user.id)
      render(conn, "history.html", changeset: changeset, friends: friends, debts: old_debts, charges: old_charges, id: id)
    else
      friends = Friendships.list_my_friends(conn.assigns.current_user.email) |> Enum.map(&{"#{&1.name} #{&1.surname}, #{&1.email}", &1.id})
      changeset = Debts.change_debt(%Debt{creator: conn.assigns.current_user.id})
      render(conn, "history.html", changeset: changeset, friends: friends, debts: "xd", charges: "xd", id: 0)
    end
  end

  def show(conn, %{"debt" => debt}) do
    %{"debtor" => id} = debt
    conn
    |>redirect(to: Routes.debt_path(conn, :history, id: id))
  end

  def custompay(conn, _params) do
    friends = Debts.list_my_friends_debt(conn.assigns.current_user.id)  |> Enum.map(&{"#{&1.name} #{&1.surname}, #{&1.email}", &1.id})
    changeset = Debts.change_debt(%Debt{})
    render(conn, "custompay.html", changeset: changeset, friends: friends)
  end

  def custom(conn, %{"debt" => debt}) do
    {id, _tail} = Integer.parse(debt["debtor"])
    case Integer.parse(debt["value"]) do
      :error ->
        conn
        |> put_flash(:error,"Wrong cash transfer size.")
        |> redirect(to: Routes.debt_path(conn, :custompay))
      {value ,_tail} ->
        debt_value = Debts.get_debts_value(id, conn.assigns.current_user.id)
        if value>0 and value<=debt_value do
          Debts.debts_paid(value,id, conn.assigns.current_user.id)
          conn
          |> put_flash(:info,"Debts paid succesfully.")
          |> redirect(to: Routes.debt_path(conn, :index))
        else
          conn
          |> put_flash(:error,"Wrong cash transfer size.")
          |> redirect(to: Routes.debt_path(conn, :custompay))
        end
    end
  end
end
