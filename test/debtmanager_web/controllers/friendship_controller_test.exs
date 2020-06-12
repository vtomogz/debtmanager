defmodule DebtmanagerWeb.FriendshipControllerTest do
  use DebtmanagerWeb.ConnCase

  alias Debtmanager.Friendships

  @create_attrs %{accepted: true, user1: "some user1", user2: "some user2"}
  @update_attrs %{accepted: false, user1: "some updated user1", user2: "some updated user2"}
  @invalid_attrs %{accepted: nil, user1: nil, user2: nil}

  def fixture(:friendship) do
    {:ok, friendship} = Friendships.create_friendship(@create_attrs)
    friendship
  end

  describe "index" do
    test "lists all friendships", %{conn: conn} do
      conn = get(conn, Routes.friendship_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Friendships"
    end
  end

  describe "new friendship" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.friendship_path(conn, :new))
      assert html_response(conn, 200) =~ "New Friendship"
    end
  end

  describe "create friendship" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.friendship_path(conn, :create), friendship: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.friendship_path(conn, :show, id)

      conn = get(conn, Routes.friendship_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Friendship"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.friendship_path(conn, :create), friendship: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Friendship"
    end
  end

  describe "edit friendship" do
    setup [:create_friendship]

    test "renders form for editing chosen friendship", %{conn: conn, friendship: friendship} do
      conn = get(conn, Routes.friendship_path(conn, :edit, friendship))
      assert html_response(conn, 200) =~ "Edit Friendship"
    end
  end

  describe "update friendship" do
    setup [:create_friendship]

    test "redirects when data is valid", %{conn: conn, friendship: friendship} do
      conn = put(conn, Routes.friendship_path(conn, :update, friendship), friendship: @update_attrs)
      assert redirected_to(conn) == Routes.friendship_path(conn, :show, friendship)

      conn = get(conn, Routes.friendship_path(conn, :show, friendship))
      assert html_response(conn, 200) =~ "some updated user1"
    end

    test "renders errors when data is invalid", %{conn: conn, friendship: friendship} do
      conn = put(conn, Routes.friendship_path(conn, :update, friendship), friendship: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Friendship"
    end
  end

  describe "delete friendship" do
    setup [:create_friendship]

    test "deletes chosen friendship", %{conn: conn, friendship: friendship} do
      conn = delete(conn, Routes.friendship_path(conn, :delete, friendship))
      assert redirected_to(conn) == Routes.friendship_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.friendship_path(conn, :show, friendship))
      end
    end
  end

  defp create_friendship(_) do
    friendship = fixture(:friendship)
    %{friendship: friendship}
  end
end
