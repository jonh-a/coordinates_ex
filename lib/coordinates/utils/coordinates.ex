defmodule Coordinates.Utils.Coordinates do
  @doc """
  Fetch a random country using the Geojson API countries list.
  """
  def get_random_country() do
    Coordinates.Utils.Common.make_get_request("https://geojson-api.usingthe.computer/countries")
    |> Enum.random()
    |> Map.get("name")
  end

  # fetches the geojson for a country from the geojson-api
  defp get_country_geojson(country) do
    Coordinates.Utils.Common.make_get_request(
      "https://geojson-api.usingthe.computer/countries/#{URI.encode(country)}?detail=10m"
    )
  end

  # generates a random set of coordinates inside a bbox
  defp generate_random_coordinates_inside_bbox(bbox) do
    [zero, one, two, three] = bbox

    lat = Float.round(:rand.uniform() * (three - one) + one, 6)
    lon = Float.round(:rand.uniform() * (two - zero) + zero, 6)
    [lat, lon]
  end

  # takes a geojson polygon and converts the coordinates from lists to tuples, reversing lon and lat
  defp convert_polygon(polygon) do
    case polygon[:type] do
      "Polygon" ->
        coordinates =
          polygon[:coordinates]
          |> Enum.map(fn coords ->
            coords |> Enum.map(fn [x, y] -> {x, y} end)
          end)

        %{polygon | coordinates: coordinates}

      "MultiPolygon" ->
        coordinates =
          polygon[:coordinates]
          |> Enum.map(fn outer_structure ->
            outer_structure
            |> Enum.map(fn coords ->
              coords |> Enum.map(fn [x, y] -> {x, y} end)
            end)
          end)

        %{polygon | coordinates: coordinates}

      _ ->
        raise "Unknown data type: #{polygon[:type]}"
        polygon
    end
  end

  # recursive function that generates random coordinates from a bbox until the coordinates are inside the country's borders
  defp generate_coordinates_until_inside_border(geometry, bbox) do
    [lat, lon] = generate_random_coordinates_inside_bbox(bbox)
    point = %{type: "Point", coordinates: {lon, lat}}

    case Topo.contains?(geometry, point) do
      true -> [lat, lon]
      false -> generate_coordinates_until_inside_border(geometry, bbox)
    end
  end

  @doc """
  Generates random coordinates inside a given country's borders as [lat, lon].

  ## Examples
      iex > Coordinates.Utils.get_random_coordinates("brazil")
      [-10.166779, -48.603361]

      iex > Coordinates.Utils.get_random_coordinates("usa")
      [37.054321, -106.734939]
  """
  def get_random_coordinates(country) do
    geojson = get_country_geojson(country)
    bbox = Map.get(geojson, "bbox")

    Map.get(geojson, "geometry")
    |> Map.new(fn {k, v} -> {String.to_existing_atom(k), v} end)
    |> convert_polygon()
    |> generate_coordinates_until_inside_border(bbox)
  end
end
