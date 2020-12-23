defmodule VpsWeb.ShipLive do
  use VpsWeb, :live_view
  alias VpsWeb.ShipComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <%= live_component @socket, ShipComponent, id: :ship %>
    """
  end
end
