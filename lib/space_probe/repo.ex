defmodule SpaceProbe.Repo do
  use Ecto.Repo,
    otp_app: :space_probe,
    adapter: Ecto.Adapters.Postgres
end
