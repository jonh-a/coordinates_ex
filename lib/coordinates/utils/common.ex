defmodule Coordinates.Utils.Common do
  @doc """
  Make get request to URL and return json. If unsuccessful, then return nil.
  """
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

  @doc """
  Seperate include query parameter into a list of lowercase values
  """
  def parse_include_param(include \\ "") do
    String.downcase(include)
    |> String.split(",")
  end

  @doc """
  Validate that a coordinate is a float
  """
  def validate_coordinate(coord) do
    try do
      String.to_float(coord)
    rescue
      ArgumentError -> nil
    end
  end

  @doc """
  Parse the output of Task.yield_many into just the results
  """
  def parse_tasks(tasks) do
    Enum.reduce(tasks, %{}, fn result, acc -> Map.merge(acc, parse_task(result)) end)
  end

  defp parse_task(task) do
    Tuple.to_list(task)
    |> Enum.at(1, %{})
    |> Tuple.to_list()
    |> Enum.at(1, %{})
  end

  @doc """
  Fetch coordinate data based on the requested data in the `include` query parameter.
  Returns a map of data.
  """
  def fetch_data_for_coordinates(coords, params) do
    include =
      case Map.has_key?(params, "include") do
        true -> parse_include_param(params["include"])
        false -> []
      end

    data = %{coordinates: coords}

    weather_task =
      if Enum.member?(include, "weather") do
        Task.async(fn ->
          %{weather: Coordinates.Utils.Weather.get_weather_for_coordinates(coords)}
        end)
      else
        nil
      end

    geocoding_task =
      if Enum.member?(include, "geocoding") do
        Task.async(fn ->
          %{geocoding: Coordinates.Utils.Geocoding.get_geocoding_data_for_coordinates(coords)}
        end)
      else
        nil
      end

    tasks = [weather_task, geocoding_task] |> Enum.filter(&(&1 != nil)) |> Task.yield_many()

    parse_tasks(tasks) |> Map.merge(data)
  end
end
