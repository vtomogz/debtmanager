defmodule Debtmanager.Friendships do

  import Ecto.Query, warn: false
  alias Debtmanager.Repo

  alias Debtmanager.Friendships.Friendship
  alias Debtmanager.Users.User

  def create_friendship(attrs \\%{}) do
    %Friendship{}
    |> Friendship.inviting_changeset(attrs)
    |> Repo.insert
  end

  def list_my_friends(email) do
    email
    |> get_my_friends
    |> get_users_info(email)
  end

  defp get_my_friends(my_email) do
    query = from f in Friendship, where: (f.user1==^my_email or f.user2==^my_email) and f.accepted==true
    Repo.all(query)
  end

  defp get_users_info(friendships,email) do
    users_info = for friendship <- friendships do
      user = get_user(friendship, email)
      query = from u in User, where: u.email==^user
      Repo.all(query)
    end
    List.flatten(users_info)
  end

  defp get_user(friendship, email) do
    case email==friendship.user1 do
      true -> friendship.user2
      _ -> friendship.user1
    end
  end

  def list_my_friend_requests(email) do
    email
    |> get_my_friends_requests
    |> get_users_info(email)
  end

  defp get_my_friends_requests(email) do
    query = from f in Friendship, where: f.user2==^email and f.accepted==false
    Repo.all(query)
  end

  def add_friendship(friend, my_email) do
    %Friendship{user1: my_email, user2: "", accepted: false}
    |> Friendship.inviting_changeset(friend)
    |> Repo.insert()
  end

  def accept_friend_request(%Friendship{} = friendship) do
    attrs = %{accepted: true}
    friendship
    |> Friendship.accepting_changeset(attrs)
    |> Repo.update()
  end

  def deny_friendship(%Friendship{} = friendship) do
    Repo.delete(friendship)
  end

  def get_single_friendship_request(owner, my_email) do
    query = from f in Friendship, where: (f.user1==^owner and f.user2==^my_email) or (f.user1==^my_email and f.user2==^owner)
    Repo.all(query)
  end

end
