defmodule CoordinatesWeb.StatusController do
  use CoordinatesWeb, :controller

  def status(conn, _params) do
    json(conn, %{status: "OK"})
  end
end
