defmodule AlbionRoadWeb.TravelController do
  use AlbionRoadWeb, :controller

  alias AlbionRoad.Services.TravelService
  alias AlbionRoad.Structs.TravelStruct

  def show(conn, params) do
    with {:ok, body} <- File.read("priv/data/items.json"),
         {:ok, _json} <- Jason.decode(body),
         {:ok, %TravelStruct{} = response} <- TravelService.call(params) do
      conn
      |> put_status(:ok)
      |> render("travel.json", json: response)
    else
      {:error, response} -> handle_erros(conn, response)
    end
  end

  defp handle_erros(conn, %TravelStruct{} = result) do
    from = check_nil("From", result.from)
    to = check_nil("To", result.to)

    conn
    |> put_status(:bad_request)
    |> render("travel.json", json: %TravelStruct{from: from, to: to})
  end

  defp check_nil(key, value) when value == nil, do: "#{key} city not found!"
  defp check_nil(_key, value), do: value
end
