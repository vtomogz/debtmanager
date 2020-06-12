alias Debtmanager.Friendships
alias Debtmanager.Users

users = [
  %{
    email: "qaz1@gmail.com",
    name: "James",
    surname: "Bond",
    password: "123456789",
    password_confirmation: "123456789"
  },
  %{
    email: "qaz2@gmail.com",
    name: "Robert",
    surname: "Kubica",
    password: "123456789",
    password_confirmation: "123456789"
  },
  %{
    email: "qaz3@gmail.com",
    name: "Jan",
    surname: "Kowalski",
    password: "123456789",
    password_confirmation: "123456789"
  },
  %{
    email: "qaz4@gmail.com",
    name: "Andrew",
    surname: "Pipe",
    password: "123456789",
    password_confirmation: "123456789"
  },
  %{
    email: "qaz5@gmail.com",
    name: "Lucas",
    surname: "Graham",
    password: "123456789",
    password_confirmation: "123456789"
  }
]

friendships = [
  %{
    user1: "qaz1@gmail.com",
    user2: "qaz2@gmail.com",
    accepted: true
  },
  %{
    user1: "qaz3@gmail.com",
    user2: "qaz1@gmail.com",
    accepted: true
  },
  %{
    user1: "qaz1@gmail.com",
    user2: "qaz4@gmail.com",
    accepted: false
  },
  %{
    user1: "qaz5@gmail.com",
    user2: "qaz1@gmail.com",
    accepted: false
  }
]

Enum.each(users, fn(data) ->
  Users.create_user(data)
end)

Enum.each(friendships, fn(data) ->
  Friendships.create_friendship(data)
end)
