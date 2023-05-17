defmodule CoordinatesWeb.GivenLocationController do
  use CoordinatesWeb, :controller

  def given_location(conn, params) do
    IO.inspect(params)
    lat = Map.get(params, "lat", nil) |> Utils.Common.validate_coordinate()
    lon = Map.get(params, "lon", nil) |> Utils.Common.validate_coordinate()

    if lat == nil do
      conn
      |> put_status(404)
      |> json(%{error: "invalid latitude provided"})
    end

    if lon == nil do
      conn
      |> put_status(404)
      |> json(%{error: "invalid longitude provided"})
    end

    coords = [lat, lon]

    include =
      case Map.has_key?(params, "include") do
        true -> Utils.Common.parse_include_param(params["include"])
        false -> []
      end

    data = %{coordinates: coords}

    data =
      if Enum.member?(include, "weather") == true do
        weather = %{weather: Utils.Weather.get_weather_for_coordinates(coords)}
        Map.merge(data, weather)
      else
        data
      end

    data =
      if Enum.member?(include, "geocoding") == true do
        geocoding = %{geocoding: Utils.Geocoding.get_geocoding_data_for_coordinates(coords)}
        Map.merge(data, geocoding)
      else
        data
      end

    json(conn, data)
  end
end
