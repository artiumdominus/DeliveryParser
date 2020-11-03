defmodule DeliveryParser.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DeliveryParser.Repo,
      # Start the Telemetry supervisor
      # DeliveryParserWeb.Telemetry,
      # Start the PubSub system
      # {Phoenix.PubSub, name: DeliveryParser.PubSub},
      # Start the Endpoint (http/https)
      DeliveryParserWeb.Endpoint
      # Start a worker by calling: DeliveryParser.Worker.start_link(arg)
      # {DeliveryParser.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DeliveryParser.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DeliveryParserWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
