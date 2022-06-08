defmodule Notifyapp.Repo do
  use Ecto.Repo,
    otp_app: :notifyapp,
    adapter: Ecto.Adapters.Postgres
end
