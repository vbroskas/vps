defmodule Vps.Store do
  use Agent

  def start_link(initial_value) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def get_all_ships do
    # Agent.get(__MODULE__, & &1)
    Agent.get(__MODULE__, fn state -> Map.keys(state) end)
  end

  def get_pilots_for_ship(ship_name) do
    Agent.get(__MODULE__, fn state -> state[ship_name] end)
  end
end
