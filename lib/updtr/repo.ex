defmodule Updtr.Repo do
  use Ecto.Repo,
    otp_app: :updtr,
    adapter: Ecto.Adapters.Postgres
end
