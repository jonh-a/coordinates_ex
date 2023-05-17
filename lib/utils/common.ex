defmodule Utils.Common do
  def make_get_request(url, headers \\ [], default \\ nil) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:ok, json} -> json
          _ -> default
        end

      _ ->
        default
    end
  end

  def parse_include_param(include \\ "") do
    String.downcase(include)
    |> String.split(",")
  end

  def validate_coordinate(coord) do
    try do
      String.to_float(coord)
    rescue
      ArgumentError -> nil
    end
  end
end
