defmodule CoordinatesWeb.UtilsCoordinatesTest do
  use ExUnit.Case

  test "fetching random coordinates works" do
    [lat, lon] = Coordinates.Utils.Coordinates.get_random_coordinates("brazil")
    assert is_float(lat) == true
    assert is_float(lon) == true
  end

  test "fetching random country works" do
    assert is_bitstring(Coordinates.Utils.Coordinates.get_random_country()) == true
  end
end
