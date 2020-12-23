defmodule Vps.StoreSupervisor do
  use Supervisor
  alias Vps.Api

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Vps.Store, Api.get_ships()}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
