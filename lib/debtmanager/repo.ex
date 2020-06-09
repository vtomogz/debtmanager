defmodule Debtmanager.Repo do
  use Ecto.Repo,
    otp_app: :debtmanager,
    adapter: Ecto.Adapters.Postgres
end
