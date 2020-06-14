defmodule Debtmanager.Debts.Debtu do
  use Ecto.Schema
  import Ecto.Changeset

  alias Debtmanager.Users.User

  schema "debtsu" do
    field :value, :integer
    field :reminder, :boolean
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(debt, attrs) do
    debt
    |> cast(attrs, [:id, :value, :user])
    |> validate_required([:id, :value, :user])
  end
end
