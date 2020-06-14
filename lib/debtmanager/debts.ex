defmodule Debtmanager.Debts do
  @moduledoc """
  The Debts context.
  """
  import Ecto.Changeset
  import Ecto.Query, warn: false
  alias Debtmanager.Repo

  alias Debtmanager.Debts.Debt
  alias Debtmanager.Debts.Debtu
  alias Debtmanager.Users.User

  @doc """
  Returns the list of debts.

  ## Examples

      iex> list_debts()
      [%Debt{}, ...]

  """

  def debts_paid(value, id, my_id) do
    if value==0 do
      :ok
    else
      debt = get_debts(id, my_id) |> List.first
      if debt.value<=value do
        d = get_debt!(debt.id)
        pay(d)
        debts_paid(value-debt.value,id,my_id)
      else
        if debt.value>value do
          d = get_debt!(debt.id)
          decrease(d,debt.value-value)
          debts_paid(0,id,my_id)
        end
      end
    end
  end

  def get_debts(id, my_id) do
    query = from d in Debt, where: d.debtor==^my_id and d.creator==^id and d.paid==false
    Repo.all(query)
  end

  def get_debts_value(id, my_id) do
    query = from d in Debt, where: d.debtor==^my_id and d.creator==^id and d.paid==false, select: d.value
    Repo.all(query)
    |> Enum.sum
  end

  def list_my_friends_debt(id) do
    query = from d in Debt, where: d.debtor==^id and d.paid==false, distinct: d.creator
    Repo.all(query)
    |> get_users_info

  end

  def get_users_info(debts) do
    users = for debt <- debts do
      query = from u in User, where: u.id==^debt.creator
      Repo.all(query)
    end
    List.flatten(users)
  end


  def get_old_debts(id, my_id) do
    query = from d in Debt, where: d.creator==^id and d.debtor==^my_id and d.paid==true
    Repo.all(query)
    |> get_creators_info
  end

  def get_old_charges(id, my_id) do
    query = from d in Debt, where: d.creator==^my_id and d.debtor==^id and d.paid==true
    Repo.all(query)
    |> get_debtors_info
  end

  def get_reminders(id) do
    query = from d in Debt, where: d.debtor==^id and d.reminder==true and d.paid==false
    Repo.all(query)
    |> get_creators_info()
  end

  def get_debts_info(id) do
    query = from d in Debt, where: d.debtor==^id and d.paid==false, select: d.value
    debts = Repo.all(query)
    [length(debts), Enum.sum(debts)]
  end

  def get_charges_info(id) do
    query = from d in Debt, where: d.creator==^id and d.paid==false, select: d.value
    debts = Repo.all(query)
    [length(debts), Enum.sum(debts)]
  end

  def list_my_charges(id) do
    query = from d in Debt, where: d.creator==^id and d.paid==false
    Repo.all(query)
    |> get_debtors_info
  end

  def get_debtors_info(debts) do
    for debt <- debts do
      %Debtu{id: debt.id, user: Repo.get!(User, debt.debtor), value: debt.value, updated_at: debt.updated_at}
    end
  end

  def list_my_debts(id) do
    query = from d in Debt, where: d.debtor==^id and d.paid==false
    Repo.all(query)
    |> get_creators_info()
  end

  def get_creators_info(debts) do
    for debt <- debts do
      %Debtu{id: debt.id, user: Repo.get!(User, debt.creator), value: debt.value, reminder: debt.reminder, updated_at: debt.updated_at}
    end
  end

  def list_debts do
    Repo.all(Debt)
  end

  @doc """
  Gets a single debt.

  Raises `Ecto.NoResultsError` if the Debt does not exist.

  ## Examples

      iex> get_debt!(123)
      %Debt{}

      iex> get_debt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_debt!(id), do: Repo.get!(Debt, id)

  @doc """
  Creates a debt.
  case Integer.parse(debtor_id) do
    :error ->
      changeset = cast(%Debt{},%{value: "sdfsdfs"},[:creator,:debtor,:value,:reminder])
      add_error(changeset, :debtor,"Nor a number")
      {:error, changeset}
    {debtor_id, _tail} ->
      case Integer.parse(value) do
        :error ->
            changeset = cast(%Debt{},%{value: "sdfsdfs"},[:creator,:debtor,:value,:reminder])
            add_error(changeset, :value,"Nor a number")
            {:error, changeset}
        {value, _tail} ->
          %{"debtor" => debtor_id, "value" => value, "reminder" => false, "creator" => id}
          |> create_debt
      end
    end
  ## Examples

      iex> create_debt(%{field: value})
      {:ok, %Debt{}}

      iex> create_debt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def add_debt(id, %{"debtor" => debtor_id, "value" => value}) do
    %{"debtor" => debtor_id, "value" => value, "reminder" => false, "paid" => false, "creator" => id}
    |> create_debt



  end

  def create_debt(attrs \\ %{}) do
    %Debt{}
    |> Debt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a debt.

  ## Examples

      iex> update_debt(debt, %{field: new_value})
      {:ok, %Debt{}}

      iex> update_debt(debt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
"""

  def remind(debt) do
    attrs= %{reminder: true}
    update_debt(debt, attrs)
  end

  def decrease(debt, size) do
    attrs= %{value: size}
    update_debt(debt, attrs)
  end

  def pay(debt) do
    attrs= %{paid: true}
    update_debt(debt, attrs)
  end

  def update_debt(%Debt{} = debt, attrs) do
    debt
    |> Debt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a debt.

  ## Examples

      iex> delete_debt(debt)
      {:ok, %Debt{}}

      iex> delete_debt(debt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_debt(%Debt{} = debt) do
    Repo.delete(debt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking debt changes.

  ## Examples

      iex> change_debt(debt)
      %Ecto.Changeset{data: %Debt{}}

  """
  def change_debt(%Debt{} = debt, attrs \\ %{}) do
    Debt.changeset(debt, attrs)
  end
end
