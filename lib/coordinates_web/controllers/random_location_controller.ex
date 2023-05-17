defmodule CoordinatesWeb.RandomLocationController do
  use CoordinatesWeb, :controller

  def random_location(conn, params) do
    country =
      case Map.has_key?(params, "country") do
        true -> params["country"]
        false -> Coordinates.Utils.Coordinates.get_random_country()
      end

    coords = Coordinates.Utils.Coordinates.get_random_coordinates(country)

    data = Coordinates.Utils.Common.fetch_data_for_coordinates(coords, params)

    json(conn, data)
  end
end
