defmodule Utils.Common do
  def make_get_request(url, headers \\ []) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Poison.decode(body) do
          {:ok, json} -> json
          _ -> nil
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        nil

      {:error, %HTTPoison.Error{}} ->
        nil
    end
  end
end
