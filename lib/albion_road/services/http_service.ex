defmodule AlbionRoad.Services.HttpService do
  alias AlbionRoad.Structs.TravelStruct

  @base_url "https://www.albion-online-data.com/api/v2/"
  @prices_url @base_url <> "stats/prices/"

  def get_prices(%TravelStruct{} = cities, items) do
    Enum.map(items, fn item -> item["UniqueName"] end)
    # TODO: Voltar filtro apenas para "T" quando estiver fazendo requests async
    |> Enum.filter(fn item -> String.slice(item, 0..1) == "T8" end)
    |> Enum.chunk_every(70)
    |> Enum.map(fn chunk -> create_url(chunk, cities) end)
    |> Enum.map(fn request -> HTTPoison.get(request) end)
    |> Enum.map(fn response -> handle_response(response) end)
  end

  defp create_url(items_list, %TravelStruct{} = cities) do
    items = Enum.join(items_list, ",")
    @prices_url <> items <> get_cities(cities)
  end

  defp get_cities(%TravelStruct{} = cities) do
    "?locations=" <> cities.from <> "," <> cities.to
  end

  defp handle_response({:ok, %HTTPoison.Response{} = response}), do: Jason.decode!(response.body)

  defp handle_response({:error, %HTTPoison.Error{} = response}),
    do: Jason.decode!(response.reason)
end
