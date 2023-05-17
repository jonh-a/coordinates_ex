defmodule CoordinatesWeb.Middleware.Logger do
  @behaviour Plug

  def init(opts), do: opts

  defp log_ip(conn) do
    ip =
      conn.remote_ip
      |> Tuple.to_list()
      |> Enum.join(".")

    id = System.get_env("PANTRY_ID")
    basket = PantryEx.get_basket(id, "coordinates_logs")

    case basket do
      {:error, _message} ->
        PantryEx.create_or_replace_basket!(
          id,
          "coordinates_logs",
          Map.put(%{}, ip, %{
            "access_count" => 1,
            "last_accessed" => DateTime.utc_now() |> DateTime.to_unix()
          })
        )

      {:ok, contents} ->
        access_count = Map.get(contents, ip, %{"access_count" => 0}) |> Map.get("access_count", 0)

        new_access_count =
          case is_integer(access_count) do
            true -> access_count + 1
            false -> 0
          end

        PantryEx.update_basket!(
          id,
          "coordinates_logs",
          %{
            ip => %{
              "access_count" => new_access_count,
              "last_accessed" => DateTime.utc_now() |> DateTime.to_unix()
            }
          }
        )
    end
  end

  @doc """
  Update pantry basket with access logs per IP
  """
  def call(conn, _opts) do
    try do
      Task.start(fn -> log_ip(conn) end)
      conn
    catch
      _exception -> conn
    end
  end
end
