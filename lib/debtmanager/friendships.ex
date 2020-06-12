defmodule Debtmanager.Friendships do
  @moduledoc """
  The Friendships context.
  """

  import Ecto.Query, warn: false
  alias Debtmanager.Repo

  alias Debtmanager.Friendships.Friendship
  alias Debtmanager.Users.User

  @doc """
  Returns the list of friendships.

  ## Examples

      iex> list_friendships()
      [%Friendship{}, ...]

  """
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

  @doc """
  Gets a single friendship.

  Raises `Ecto.NoResultsError` if the Friendship does not exist.

  ## Examples

      iex> get_friendship!(123)
      %Friendship{}

      iex> get_friendship!(456)
      ** (Ecto.NoResultsError)

  """

  @doc """
  Creates a friendship.

  ## Examples

      iex> create_friendship(%{field: value})
      {:ok, %Friendship{}}

      iex> create_friendship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_friendship(friend, my_email) do
    xd = %Friendship{user1: my_email, user2: "", accepted: false}
    |> Friendship.inviting_changeset(friend)
    IO.inspect(xd)

    Repo.insert(xd)
  end

  @doc """
  Updates a friendship.

  ## Examples

      iex> update_friendship(friendship, %{field: new_value})
      {:ok, %Friendship{}}

      iex> update_friendship(friendship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def accept_friend_request(%Friendship{} = friendship) do
    attrs = %{accepted: true}
    friendship
    |> Friendship.accepting_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a friendship.

  ## Examples

      iex> delete_friendship(friendship)
      {:ok, %Friendship{}}

      iex> delete_friendship(friendship)
      {:error, %Ecto.Changeset{}}

  """
  def deny_friendship(%Friendship{} = friendship) do
    Repo.delete(friendship)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking friendship changes.

  ## Examples

      iex> change_friendship(friendship)
      %Ecto.Changeset{data: %Friendship{}}

  """
  def get_single_friendship_request(owner, my_email) do
    query = from f in Friendship, where: (f.user1==^owner and f.user2==^my_email) or (f.user1==^my_email and f.user2==^owner)
    [result] = Repo.all(query)
    result
  end

end
