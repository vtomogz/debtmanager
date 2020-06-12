defmodule Debtmanager.Friendships.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Debtmanager.Repo
  alias Debtmanager.Users.User
  alias Debtmanager.Friendships.Friendship

  schema "friendships" do
    field :accepted, :boolean, default: false
    field :user1, :string
    field :user2, :string

    timestamps()
  end

  @doc false
  def inviting_changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:user1, :user2, :accepted])
    |> validate_required([:user1, :user2, :accepted])
    |> validate_diffrent_users(:user1 ,:user2)
    |> validate_user_exists(:user2)
    |> validate_relation_already_exists(:user1, :user2)
  end

  def accepting_changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:user1, :user2, :accepted])
    |> validate_required([:user1, :user2, :accepted])
  end

  defp validate_diffrent_users(changeset, user1, user2) do
    case changeset.valid? do
      true ->
        email1 = get_field(changeset, user1)
        email2 = get_field(changeset, user2)
        case email1==email2 do
          true -> add_error(changeset, user2, "That is your email!")
          _ -> changeset
        end
      _ -> changeset
    end
  end

  defp validate_user_exists(changeset, user2) do
    case changeset.valid? do
      true ->
        email = get_field(changeset, user2)
         case Repo.get_by(User, email: email) do
           nil -> add_error(changeset, user2, "User with this email does not exists.")
           _ -> changeset

         end
      _ -> changeset
    end
  end

  defp validate_relation_already_exists(changeset, user1, user2) do
    case changeset.valid? do
      true ->
        email1 = get_field(changeset, user1)
        email2 = get_field(changeset, user2)
        query1 = from f in Friendship, where: f.user1==^email1 and f.user2==^email2
        query2 = from f in Friendship, where: f.user1==^email2 and f.user2==^email1
        friends1 = Repo.exists?(query1)
        friends2 = Repo.exists?(query2)
        case [friends1, friends2] do
          [false, false] -> changeset
          _ -> add_error(changeset, user2, "You are friends already or friend request is pending.")
        end
      _ -> changeset
    end
  end
end
