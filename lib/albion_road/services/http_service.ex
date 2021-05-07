defmodule AlbionRoad.Services.HttpService do
  alias AlbionRoad.Structs.TravelStruct

  @base_url "https://www.albion-online-data.com/api/v2/"
  @prices_url @base_url <> "stats/prices/"

  def get_prices(%TravelStruct{} = cities, items, tier \\ 4) do
    response = Enum.map(items, fn item -> item["UniqueName"] end)
    |> Enum.filter(fn item -> String.slice(item, 0..1) == "T#{tier}" end)
    |> Enum.chunk_every(80)
    |> Enum.map(fn chunk -> create_url(chunk, cities) end)
    |> Enum.map(fn request -> Task.async(fn -> HTTPoison.get(request) end) end)
    |> Enum.map(fn task -> handle_task_response(task) end)

    handle_response(response[:ok])
  end

  defp create_url(items_list, %TravelStruct{} = cities) do
    items = Enum.join(items_list, ",")
    @prices_url <> items <> get_cities(cities)
  end

  defp get_cities(%TravelStruct{} = cities) do
    "?locations=" <> cities.from <> "," <> cities.to
  end

  defp handle_task_response(%Task{} = task), do: Task.await(task)
  defp handle_response(%HTTPoison.Response{} = response), do: Jason.decode!(response.body)
  defp handle_response(%HTTPoison.Error{} = response), do: Jason.decode!(response.reason)
end
