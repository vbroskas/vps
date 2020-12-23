defmodule Vps.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Vps.Repo,
      # Start the Telemetry supervisor
      VpsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vps.PubSub},
      Vps.StoreSupervisor,
      # Start the Endpoint (http/https)
      VpsWeb.Endpoint
      # Start a worker by calling: Vps.Worker.start_link(arg)
      # {Vps.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vps.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VpsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
