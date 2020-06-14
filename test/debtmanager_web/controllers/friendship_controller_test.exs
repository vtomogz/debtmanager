defmodule DebtmanagerWeb.FriendshipControllerTest do
  use DebtmanagerWeb.ConnCase


  alias Debtmanager.Friendships

  @create_attrs %{user1: "qaz5@gmail.com", user2: "qaz4@gmail.com", accepted: false}
  @update_attrs %{user1: "qaz5@gmail.com", user2: "qaz4@gmail.com", accepted: true}
  @invalid_attrs %{creator: nil, debtor: nil, reminder: nil, value: nil}

  def fixture(:friendship) do
    {:ok, friendship} = Friendships.create_friendship(@create_attrs)
    friendship
  end

  defp create_friendship(_) do
    friendship = fixture(:friendship)
    %{friendship: friendship}
  end

  describe "index" do
    test "lists all friends, lists all friend requests, add friend form", %{authed_conn: authed_conn} do
      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end
  end

  describe "create friendship" do
    test "redirects to index and showing info when data is valid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.friendship_path(authed_conn, :add), friendship: @create_attrs)

      assert get_flash(conn, :info) == "Friend request sended."
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end

    test "redirects to index and showing info when data is invalid", %{authed_conn: authed_conn} do
      conn = post(authed_conn, Routes.friendship_path(authed_conn, :add), friendship: @invalid_attrs)

      assert String.valid?(get_flash(conn, :error))
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end
  end

  describe "accept friend request" do

    test "redirects to index and showing message when is valid", %{authed_conn: authed_conn} do
      conn = put(authed_conn, Routes.friendship_path(authed_conn, :accept, email: "qaz5@gmail.com"))

      assert get_flash(conn, :info) == "Friend request accepted."
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end

    test "redirects to index and showing info when data is invalid", %{authed_conn: authed_conn} do
      conn = put(authed_conn, Routes.friendship_path(authed_conn, :accept, email: nil))

      assert String.valid?(get_flash(conn, :error))
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end
  end

  describe "deny friend request" do

    test "redirects to index and showing message when is valid", %{authed_conn: authed_conn} do
      conn = delete(authed_conn, Routes.friendship_path(authed_conn, :deny, email: "qaz5@gmail.com"))

      assert get_flash(conn, :info) == "Friend request rejected."
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end

    test "redirects to index and showing info when data is invalid", %{authed_conn: authed_conn} do
      conn = delete(authed_conn, Routes.friendship_path(authed_conn, :deny, email: nil))

      assert String.valid?(get_flash(conn, :error))
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end
  end

  describe "remove friend relation" do

    test "redirects to index and showing message when is valid", %{authed_conn: authed_conn} do
      conn = delete(authed_conn, Routes.friendship_path(authed_conn, :remove, email: "qaz5@gmail.com"))

      assert get_flash(conn, :info) == "Friend removed."
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end

    test "redirects to index and showing info when data is invalid", %{authed_conn: authed_conn} do
      conn = delete(authed_conn, Routes.friendship_path(authed_conn, :remove, email: nil))

      assert String.valid?(get_flash(conn, :error))
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)

      conn = get(authed_conn, Routes.friendship_path(authed_conn, :index))
      assert html_response(conn, 200) =~ "My Friends"
      assert html_response(conn, 200) =~ "Add Friend"
      assert html_response(conn, 200) =~ "Friends Requests"
    end
  end

end
