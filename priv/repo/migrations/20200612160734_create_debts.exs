defmodule Debtmanager.Repo.Migrations.CreateDebts do
  use Ecto.Migration

  def change do
    create table(:debts) do
      add :creator, :integer
      add :debtor, :integer
      add :value, :integer
      add :reminder, :boolean, default: false, null: false
      add :paid, :boolean, default: false, null: false

      timestamps()
    end

  end
end
