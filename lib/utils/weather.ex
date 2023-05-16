defmodule Utils.Weather do
  def get_weather_for_coordinates(coordinates \\ [0, 0]) do
    [lat, lon] = coordinates
    key = System.get_env("OPENWEATHERMAP_API_KEY")
    IO.inspect(key)

    Utils.Common.make_get_request(
      "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{key}&units=imperial"
    )
    |> parse_weather()
  end

  defp parse_weather(w) do
    main = Map.get(w, "main")
    sys = Map.get(w, "sys")
    visibility = Map.get(w, "visibility")
    weather = Map.get(w, "weather") |> List.first(%{})

    feels_like = Map.get(main, "feels_like", 0)
    humidity = Map.get(main, "humidity", 0)
    pressure = Map.get(main, "pressure", 0)
    temp_max = Map.get(main, "temp_max", 0)
    temp_min = Map.get(main, "temp_min", 0)

    sunrise = Map.get(sys, "sunrise", 0)
    sunset = Map.get(sys, "sunset", 0)

    description = Map.get(weather, "description", "")

    %{
      feels_like: feels_like,
      humidity: humidity,
      pressure: pressure,
      temp_max: temp_max,
      temp_min: temp_min,
      sunrise: sunrise,
      sunset: sunset,
      description: description,
      visibility: visibility
    }
  end
end
