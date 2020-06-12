defmodule Debtmanager.Repo.Migrations.CreateDebts do
  use Ecto.Migration

  def change do
    create table(:debts) do
      add :creator, :string
      add :debtor, :string
      add :value, :integer
      add :reminder, :boolean, default: false, null: false

      timestamps()
    end

  end
end
