defmodule Debtmanager.Users do

  import Ecto.Query, warn: false
  alias Debtmanager.Repo

  alias Debtmanager.Users.User

  def create_user(attrs \\%{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert
  end

end
