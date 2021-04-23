defmodule AlbionRoad.Repo do
  use Ecto.Repo,
    otp_app: :albion_road,
    adapter: Ecto.Adapters.Postgres
end
