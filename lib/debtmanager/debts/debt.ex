defmodule Debtmanager.Debts.Debt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "debts" do
    field :creator, :integer
    field :debtor, :integer
    field :reminder, :boolean, default: false
    field :value, :integer
    field :paid, :boolean

    timestamps()
  end

  @doc false
  def changeset(debt, attrs) do
    debt
    |> cast(attrs, [:creator, :debtor, :value, :reminder, :paid])
    |> validate_required([:creator, :debtor, :value, :reminder, :paid])
    |> validate_number(:value, greater_than: 0, less_than: 2147483647)


  end

end
