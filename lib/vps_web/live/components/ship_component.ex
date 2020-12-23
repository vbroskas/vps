defmodule VpsWeb.ShipComponent do
  use VpsWeb, :live_component
  alias Vps.Store

  def mount(socket) do
    ship_map =
      Store.get_all_ships()
      |> process_ship()

    socket =
      socket
      |> assign(:ships, ship_map)
      |> assign(pilots: false)

    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <div class="parent white">
    <%= for {key, value} <- @ships do %>
    <div class="card"
    phx-click="click-ship"
    phx-target="<%= @myself %>"
    phx-value-ship="<%= key %>"
    id="<%= key %>"
    >
    <h3><%= key %></h3>

    <%= if value[:status] == true do %>
    <ul>
    <%= for pilot <- value[:pilots] do %>
    <li class="li-text"><%= pilot %></li>

    <% end %>

    </ul>

      <% else %>

      <% end %>


    </div>
      <% end %>

    </div>
    """
  end

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @spec process_ship(list) :: map
  def process_ship(ship_list) do
    Enum.reduce(ship_list, %{}, fn ship, acc ->
      Map.put(acc, ship, %{status: false, pilots: Store.get_pilots_for_ship(ship)})
    end)
  end

  def handle_event("click-ship", %{"ship" => ship}, socket) do
    # get opposite of current status for this ship
    ship_status = !Map.get(socket.assigns.ships[ship], :status, false)
    # put that new status in assigns map of ships
    ships = put_in(socket.assigns.ships, [ship, :status], ship_status)

    socket =
      socket
      |> assign(ships: ships)

    {:noreply, socket}
  end
end
