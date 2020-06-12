defmodule Debtmanager.FriendshipsTest do
  use Debtmanager.DataCase

  alias Debtmanager.Friendships

  describe "friendship" do
    alias Debtmanager.Friendships.Friendship

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def friendship_fixture(attrs \\ %{}) do
      {:ok, friendship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Friendships.create_friendship()

      friendship
    end

    test "list_friendship/0 returns all friendship" do
      friendship = friendship_fixture()
      assert Friendships.list_friendship() == [friendship]
    end

    test "get_friendship!/1 returns the friendship with given id" do
      friendship = friendship_fixture()
      assert Friendships.get_friendship!(friendship.id) == friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      assert {:ok, %Friendship{} = friendship} = Friendships.create_friendship(@valid_attrs)
    end

    test "create_friendship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Friendships.create_friendship(@invalid_attrs)
    end

    test "update_friendship/2 with valid data updates the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{} = friendship} = Friendships.update_friendship(friendship, @update_attrs)
    end

    test "update_friendship/2 with invalid data returns error changeset" do
      friendship = friendship_fixture()
      assert {:error, %Ecto.Changeset{}} = Friendships.update_friendship(friendship, @invalid_attrs)
      assert friendship == Friendships.get_friendship!(friendship.id)
    end

    test "delete_friendship/1 deletes the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{}} = Friendships.delete_friendship(friendship)
      assert_raise Ecto.NoResultsError, fn -> Friendships.get_friendship!(friendship.id) end
    end

    test "change_friendship/1 returns a friendship changeset" do
      friendship = friendship_fixture()
      assert %Ecto.Changeset{} = Friendships.change_friendship(friendship)
    end
  end

  describe "friendships" do
    alias Debtmanager.Friendships.Friendship

    @valid_attrs %{accapted: true, user1: "some user1", user2: "some user2"}
    @update_attrs %{accapted: false, user1: "some updated user1", user2: "some updated user2"}
    @invalid_attrs %{accapted: nil, user1: nil, user2: nil}

    def friendship_fixture(attrs \\ %{}) do
      {:ok, friendship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Friendships.create_friendship()

      friendship
    end

    test "list_friendships/0 returns all friendships" do
      friendship = friendship_fixture()
      assert Friendships.list_friendships() == [friendship]
    end

    test "get_friendship!/1 returns the friendship with given id" do
      friendship = friendship_fixture()
      assert Friendships.get_friendship!(friendship.id) == friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      assert {:ok, %Friendship{} = friendship} = Friendships.create_friendship(@valid_attrs)
      assert friendship.accapted == true
      assert friendship.user1 == "some user1"
      assert friendship.user2 == "some user2"
    end

    test "create_friendship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Friendships.create_friendship(@invalid_attrs)
    end

    test "update_friendship/2 with valid data updates the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{} = friendship} = Friendships.update_friendship(friendship, @update_attrs)
      assert friendship.accapted == false
      assert friendship.user1 == "some updated user1"
      assert friendship.user2 == "some updated user2"
    end

    test "update_friendship/2 with invalid data returns error changeset" do
      friendship = friendship_fixture()
      assert {:error, %Ecto.Changeset{}} = Friendships.update_friendship(friendship, @invalid_attrs)
      assert friendship == Friendships.get_friendship!(friendship.id)
    end

    test "delete_friendship/1 deletes the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{}} = Friendships.delete_friendship(friendship)
      assert_raise Ecto.NoResultsError, fn -> Friendships.get_friendship!(friendship.id) end
    end

    test "change_friendship/1 returns a friendship changeset" do
      friendship = friendship_fixture()
      assert %Ecto.Changeset{} = Friendships.change_friendship(friendship)
    end
  end

  describe "friendships" do
    alias Debtmanager.Friendships.Friendship

    @valid_attrs %{accepted: true}
    @update_attrs %{accepted: false}
    @invalid_attrs %{accepted: nil}

    def friendship_fixture(attrs \\ %{}) do
      {:ok, friendship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Friendships.create_friendship()

      friendship
    end

    test "list_friendships/0 returns all friendships" do
      friendship = friendship_fixture()
      assert Friendships.list_friendships() == [friendship]
    end

    test "get_friendship!/1 returns the friendship with given id" do
      friendship = friendship_fixture()
      assert Friendships.get_friendship!(friendship.id) == friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      assert {:ok, %Friendship{} = friendship} = Friendships.create_friendship(@valid_attrs)
      assert friendship.accepted == true
    end

    test "create_friendship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Friendships.create_friendship(@invalid_attrs)
    end

    test "update_friendship/2 with valid data updates the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{} = friendship} = Friendships.update_friendship(friendship, @update_attrs)
      assert friendship.accepted == false
    end

    test "update_friendship/2 with invalid data returns error changeset" do
      friendship = friendship_fixture()
      assert {:error, %Ecto.Changeset{}} = Friendships.update_friendship(friendship, @invalid_attrs)
      assert friendship == Friendships.get_friendship!(friendship.id)
    end

    test "delete_friendship/1 deletes the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{}} = Friendships.delete_friendship(friendship)
      assert_raise Ecto.NoResultsError, fn -> Friendships.get_friendship!(friendship.id) end
    end

    test "change_friendship/1 returns a friendship changeset" do
      friendship = friendship_fixture()
      assert %Ecto.Changeset{} = Friendships.change_friendship(friendship)
    end
  end

  describe "friendships" do
    alias Debtmanager.Friendships.Friendship

    @valid_attrs %{accepted: true, user1: "some user1", user2: "some user2"}
    @update_attrs %{accepted: false, user1: "some updated user1", user2: "some updated user2"}
    @invalid_attrs %{accepted: nil, user1: nil, user2: nil}

    def friendship_fixture(attrs \\ %{}) do
      {:ok, friendship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Friendships.create_friendship()

      friendship
    end

    test "list_friendships/0 returns all friendships" do
      friendship = friendship_fixture()
      assert Friendships.list_friendships() == [friendship]
    end

    test "get_friendship!/1 returns the friendship with given id" do
      friendship = friendship_fixture()
      assert Friendships.get_friendship!(friendship.id) == friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      assert {:ok, %Friendship{} = friendship} = Friendships.create_friendship(@valid_attrs)
      assert friendship.accepted == true
      assert friendship.user1 == "some user1"
      assert friendship.user2 == "some user2"
    end

    test "create_friendship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Friendships.create_friendship(@invalid_attrs)
    end

    test "update_friendship/2 with valid data updates the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{} = friendship} = Friendships.update_friendship(friendship, @update_attrs)
      assert friendship.accepted == false
      assert friendship.user1 == "some updated user1"
      assert friendship.user2 == "some updated user2"
    end

    test "update_friendship/2 with invalid data returns error changeset" do
      friendship = friendship_fixture()
      assert {:error, %Ecto.Changeset{}} = Friendships.update_friendship(friendship, @invalid_attrs)
      assert friendship == Friendships.get_friendship!(friendship.id)
    end

    test "delete_friendship/1 deletes the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{}} = Friendships.delete_friendship(friendship)
      assert_raise Ecto.NoResultsError, fn -> Friendships.get_friendship!(friendship.id) end
    end

    test "change_friendship/1 returns a friendship changeset" do
      friendship = friendship_fixture()
      assert %Ecto.Changeset{} = Friendships.change_friendship(friendship)
    end
  end
end
