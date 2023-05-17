defmodule CoordinatesWeb.ErrorJSONTest do
  use CoordinatesWeb.ConnCase, async: true

  test "status endpoint renders 200", %{conn: conn} do
    conn = get(conn, ~p"/status")
    assert json_response(conn, 200) == %{"status" => "OK"}
  end

  test "renders 404" do
    assert CoordinatesWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert CoordinatesWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
