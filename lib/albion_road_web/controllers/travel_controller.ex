defmodule AlbionRoadWeb.TravelController do
  use AlbionRoadWeb, :controller

  alias AlbionRoad.Services.TravelService
  alias AlbionRoad.Structs.{PricesStruct, TravelStruct}

  def show(conn, params) do
    with {:ok, body} <- File.read("priv/data/items.json"),
         {:ok, items} <- Jason.decode(body),
         {:ok, %TravelStruct{} = cities} <- TravelService.handle_params(params),
         {:ok, response} <- TravelService.call(cities, items) do
      conn
      |> put_status(:ok)
      |> render("travel.json", json: response)
    else
      {:error, %TravelStruct{} = cities} -> handle_params_erros(conn, cities)
    end
  end

  defp handle_params_erros(conn, %TravelStruct{} = result) do
    from = check_nil("From", result.from)
    to = check_nil("To", result.to)

    conn
    |> put_status(:bad_request)
    |> render("travel.json", json: %TravelStruct{from: from, to: to})
  end

  defp check_nil(key, value) when value == nil, do: "#{key} city not found!"
  defp check_nil(_key, value), do: value
end
