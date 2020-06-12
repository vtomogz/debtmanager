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
    case Friendships.add_friendship(friend, conn.assigns.current_user.email) do
      {:ok, _friendship} ->
        conn
        |> put_flash(:info, "Friend request sended.")
        |> redirect(to: Routes.friendship_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        [user2: {message, _tail}]=changeset.errors
        conn
        |> put_flash(:error, message)
        |> redirect(to: Routes.friendship_path(conn, :index))
    end
  end

  def accept(conn, %{"email" => email}) do
    friendship = Friendships.get_single_friendship_request(email, conn.assigns.current_user.email)
    case friendship do
      [] ->
        conn
        |> put_flash(:error, "Error occured.")
        |> redirect(to: Routes.friendship_path(conn, :index))
      [friends] ->
        case Friendships.accept_friend_request(friends) do
          {:ok, _friendship} ->
            conn
            |> put_flash(:info, "Friend request accepted.")
            |> redirect(to: Routes.friendship_path(conn, :index))
          {:error, _changeset} ->
            conn
            |> put_flash(:error, "Error occured.")
            |> redirect(to: Routes.friendship_path(conn, :index))
        end
      end
  end

  def deny(conn, %{"email" => email}) do
    friendship = Friendships.get_single_friendship_request(email, conn.assigns.current_user.email)
    case friendship do
      [] ->
        conn
        |> put_flash(:error, "Error occured.")
        |> redirect(to: Routes.friendship_path(conn, :index))
      [friends] ->
        case Friendships.deny_friendship(friends) do
          {:ok, _friendship} ->
            conn
            |> put_flash(:info, "Friend request rejected.")
            |> redirect(to: Routes.friendship_path(conn, :index))
          {:error, _changeset } ->
            conn
            |> put_flash(:error, "Error occured.")
            |> redirect(to: Routes.friendship_path(conn, :index))
        end
    end
  end

  def remove(conn, %{"email" => email}) do
    friendship = Friendships.get_single_friendship_request(email, conn.assigns.current_user.email)
    case friendship do
      [] ->
        conn
        |> put_flash(:error, "Error occured.")
        |> redirect(to: Routes.friendship_path(conn, :index))
      [friends] ->
        case Friendships.deny_friendship(friends) do
          {:ok, _friendship} ->
            conn
            |> put_flash(:info, "Friend request rejected.")
            |> redirect(to: Routes.friendship_path(conn, :index))
          {:error, _changeset } ->
            conn
            |> put_flash(:error, "Error occured.")
            |> redirect(to: Routes.friendship_path(conn, :index))
        end
    end
  end
end
