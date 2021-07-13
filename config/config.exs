# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :space_probe,
  ecto_repos: [SpaceProbe.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :space_probe, SpaceProbeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1+Udxhh/e3fuBdcfn6K4ZAlzCvJtf3IiYtDOavCwmRzePoE/OgfRCOJRlCMSbZpA",
  render_errors: [view: SpaceProbeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: SpaceProbe.PubSub,
  live_view: [signing_salt: "LR3fgoRV"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
