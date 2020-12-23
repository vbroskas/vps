defmodule Vps.Api do
  @base_url "https://swapi.dev/api/"

  @doc """
  returns:
  %{
  "CR90 corvette" => ["none"],
  "Death Star" => ["none"],
  "Executor" => ["none"],
  "Millennium Falcon" => ["Chewbacca", "Han Solo", "Lando Calrissian",
   "Nien Nunb"],
  "Rebel transport" => ["none"],
  "Sentinel-class landing craft" => ["none"],
  "Star Destroyer" => ["none"],
  "TIE Advanced x1" => ["Darth Vader"],
  "X-wing" => ["Luke Skywalker", "Biggs Darklighter", "Wedge Antilles",
   "Jek Tono Porkins"],
  "Y-wing" => ["none"]
  }

  """
  def get_ships() do
    case HTTPoison.get(@base_url <> "starships/") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body = Poison.Parser.parse!(body, %{})

        ships_map =
          Enum.reduce(body["results"], %{}, fn ship, acc ->
            Map.put(acc, ship["name"], ship["pilots"])
          end)

        final = for {k, v} <- ships_map, into: %{}, do: {k, get_name(v)}

        IO.inspect(final)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def get_name([]) do
    ["none"]
  end

  def get_name(pilots) do
    Enum.map(pilots, fn pilot -> query_pilot(pilot) end)
  end

  def query_pilot(pilot) do
    # When querying ships, the returned list of pilots are urls with "http...", need to split that out
    sub_url = String.split(pilot, "http://swapi.dev/api/", trim: true) |> List.first()

    case HTTPoison.get(@base_url <> sub_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body = Poison.Parser.parse!(body, %{})
        body["name"]

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end
end
