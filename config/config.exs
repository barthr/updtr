# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :updtr,
  ecto_repos: [Updtr.Repo],
  generators: [binary_id: true],
  media_path: "/media"

# Add support for microseconds at the DB level
# this avoids having to configure it on every migration file
config :updtr, Updtr.Repo, migration_timestamps: [type: :utc_datetime_usec]

# Configures the endpoint
config :updtr, UpdtrWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "gsFJbSuUNQmnPHv4vx0xB3E0EdadZsZb/d0PwaoEUI/qd6Oij+QK6mvX/HwuWYQI",
  render_errors: [view: UpdtrWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Updtr.PubSub, adapter: Phoenix.PubSub.PG2]

config :updtr, UpdtrWeb.Auth.Guardian,
  issuer: "updtr",
  secret_key: "ikhJW1aL/uzsZQQSxqQmyu50g+86IBEkTxMJm5zfEvLMUWE9Io0RyM8dc1kR9Sj/"

config :updtr, Updtr.Mailer, base_url: "http://localhost:4000"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
