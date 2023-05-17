defmodule CoordinatesWeb.GivenLocationController do
  use CoordinatesWeb, :controller

  def given_location(conn, params) do
    lat = Map.get(params, "lat", nil) |> Coordinates.Utils.Common.validate_coordinate()
    lon = Map.get(params, "lon", nil) |> Coordinates.Utils.Common.validate_coordinate()

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
    data = Coordinates.Utils.Common.fetch_data_for_coordinates(coords, params)

    json(conn, data)
  end
end
