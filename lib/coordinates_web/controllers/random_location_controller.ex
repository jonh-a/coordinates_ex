defmodule CoordinatesWeb.RandomLocationController do
  use CoordinatesWeb, :controller

  def random_location(conn, params) do
    include =
      case Map.has_key?(params, "include") do
        true -> Utils.Common.parse_include_param(params["include"])
        false -> []
      end

    country =
      case Map.has_key?(params, "country") do
        true -> params["country"]
        false -> Utils.Coordinates.get_random_country()
      end

    coords = Utils.Coordinates.get_random_coordinates(country)
    data = %{country: country, coordinates: coords}

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
