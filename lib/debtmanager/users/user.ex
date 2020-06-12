defmodule Debtmanager.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :name, :string
    field :surname, :string

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> Ecto.Changeset.cast(attrs, [:name, :surname])
    |> Ecto.Changeset.validate_required([:name, :surname])
  end

end
