defmodule DeliveryParser.Repo do
  use Ecto.Repo,
    otp_app: :delivery_parser,
    adapter: Ecto.Adapters.Postgres
end
