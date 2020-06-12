defmodule Debtmanager.Debts.Debt do
  use Ecto.Schema
  import Ecto.Changeset

  schema "debts" do
    field :creator, :string
    field :debtor, :string
    field :reminder, :boolean, default: false
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(debt, attrs) do
    debt
    |> cast(attrs, [:creator, :debtor, :value, :reminder])
    |> validate_required([:creator, :debtor, :value, :reminder])
  end
end
