defmodule CoordinatesWeb.UtilsCommonTest do
  use ExUnit.Case

  test "get request works" do
    res =
      Coordinates.Utils.Common.make_get_request(
        "https://postman-echo.com/get",
        [dummy: true],
        nil
      )

    dummy_header = Map.get(res, "headers", %{}) |> Map.get("dummy", nil)
    assert dummy_header == "true"
  end

  test "coordinate validation works" do
    assert Coordinates.Utils.Common.validate_coordinate("asdf") == nil
    assert Coordinates.Utils.Common.validate_coordinate("-3.145") == -3.145
  end
end
