defmodule Utils.Geocoding do
  def get_geocoding_data_for_coordinates(coordinates \\ [0, 0]) do
    [lat, lon] = coordinates

    Utils.Common.make_get_request(
      "https://nominatim.openstreetmap.org/reverse?format=json&lat=#{lat}&lon=#{lon}&addressdetails=1",
      [],
      %{}
    )
    |> parse_geocoding()
  end

  defp parse_geocoding(g) do
    address = Map.get(g, "address", %{})

    %{
      country: Map.get(address, "country", ""),
      country_code: Map.get(address, "country_code", ""),
      road: Map.get(address, "road", ""),
      state: Map.get(address, "state", ""),
      state_district: Map.get(address, "state_district", ""),
      village: Map.get(address, "village", ""),
      bounding_box: Map.get(g, "boundingbox", [0, 0, 0, 0]),
      display_name: Map.get(g, "display_name", ""),
      lat: Map.get(g, "lat", ""),
      lon: Map.get(g, "lon", "")
    }
  end
end
