defmodule Debtmanager.FriendshipTest do
  use Debtmanager.DataCase

  alias Debtmanager.Friendships

  describe "friendships" do
    alias Debtmanager.Friendships.Friendship

    @valid_attrs %{user1: "qaz5@gmail.com", user2: "qaz4@gmail.com", accepted: false}
    @update_attrs %{user1: "qaz5@gmail.com", user2: "qaz4@gmail.com", accepted: true}
    @invalid_attrs %{user1: nil, user2: nil, accepted: "moze tak moze nie kto to wie"}

    def friendship_fixture(attrs \\%{}) do
      {:ok, friendship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Friendships.create_friendship()

      friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      assert{:ok, %Friendship{} = friendship} = Friendships.create_friendship(@valid_attrs)
      assert friendship.user1 == "qaz5@gmail.com"
      assert friendship.user2 == "qaz4@gmail.com"
      assert friendship.accepted == false
    end
  end
end
