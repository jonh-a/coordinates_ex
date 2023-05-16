defmodule CoordinatesWeb.RandomLocationController do
  use CoordinatesWeb, :controller

  def random_location(conn, params) do
    country =
      case Map.has_key?(params, "country") do
        true -> params["country"]
        false -> Utils.Coordinates.get_random_country()
      end

    IO.inspect(country)

    coords = Utils.Coordinates.get_random_coordinates(country)

    json(conn, %{country: country, coords: coords})
  end
end
