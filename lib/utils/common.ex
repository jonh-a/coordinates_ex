defmodule Utils.Common do
  def make_get_request(url, headers \\ []) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:ok, json} -> json
          _ -> nil
        end

      _ ->
        nil
    end
  end

  def parse_include_param(include \\ "") do
    String.downcase(include)
    |> String.split(",")
  end
end
