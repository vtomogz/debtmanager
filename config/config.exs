# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :debtmanager,
  ecto_repos: [Debtmanager.Repo]

# Configures the endpoint
config :debtmanager, DebtmanagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "g3Ec/kveDuaoc0UZcEHRkmd9mItuqGmEJwbTS3vga8bejHjUQpK99F4/5ZZDL6rC",
  render_errors: [view: DebtmanagerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Debtmanager.PubSub,
  live_view: [signing_salt: "7ftpKB42"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :debtmanager, :pow,
  user: Debtmanager.Users.User,
  repo: Debtmanager.Repo,
  web_module: DebtmanagerWeb


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
