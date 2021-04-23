# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :albion_road,
  ecto_repos: [AlbionRoad.Repo]

# Configures the endpoint
config :albion_road, AlbionRoadWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0Lm4LTpfwxOAcsalDCjc4MEuLqhZPMVew9nZy2wd5Nwajeol+vp6Y6B+Exg6EaAR",
  render_errors: [view: AlbionRoadWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: AlbionRoad.PubSub,
  live_view: [signing_salt: "YF7nZxkL"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
