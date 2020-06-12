defmodule Debtmanager.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user1, :string
      add :user2, :string
      add :accepted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
