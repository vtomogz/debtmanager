defmodule DebtmanagerWeb.FriendshipController do
  use DebtmanagerWeb, :controller

  alias Debtmanager.Friendships
  alias Debtmanager.Friendships.Friendship

  def index(conn, _params) do
    changeset = Friendship.inviting_changeset(%Friendship{},%{})
    friendships = Friendships.list_my_friends(conn.assigns.current_user.email)
    friend_requests = Friendships.list_my_friend_requests(conn.assigns.current_user.email)
    render(conn, "index.html", friendships: friendships, friend_requests: friend_requests, changeset: changeset)
  end

  def add(conn, %{"friendship" => friend}) do
    IO.inspect(friend)
    case Friendships.add_friendship(friend, conn.assigns.current_user.email) do
      {:ok, friendship} ->
        conn
        |> put_flash(:info, "Friend request sended.")
        |> redirect(to: Routes.friendship_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect([user2: {message, _tail}]=changeset.errors)
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.friendship_path(conn, :index))
    end
  end

  def accept(conn, %{"email" => email}) do
    friendship = Friendships.get_single_friendship_request(email, conn.assigns.current_user.email)

    case Friendships.accept_friend_request(friendship) do
      {:ok, friendship} ->
        conn
        |> put_flash(:info, "Friend request accepted.")
        |> redirect(to: Routes.friendship_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, changeset)
        |> redirect(to: Routes.friendship_path(conn, :index))
    end
  end

  def deny(conn, %{"email" => email}) do
    friendship = Friendships.get_single_friendship_request(email, conn.assigns.current_user.email)
    {:ok, _friendship} = Friendships.deny_friendship(friendship)

    conn
    |> put_flash(:info, "Friend request rejected.")
    |> redirect(to: Routes.friendship_path(conn, :index))
  end

  def remove(conn, %{"email" => email}) do
    friendship = Friendships.get_single_friendship_request(email, conn.assigns.current_user.email)
    IO.inspect(friendship)
    {:ok, _friendship} = Friendships.deny_friendship(friendship)

    conn
    |> put_flash(:info, "Friend deleted.")
    |> redirect(to: Routes.friendship_path(conn, :index))
  end
end
