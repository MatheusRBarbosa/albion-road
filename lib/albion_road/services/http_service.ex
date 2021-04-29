defmodule AlbionRoad.Services.HttpService do
  # alias AlbionRoad.Structs.TravelStruct

  @base_url "https://www.albion-online-data.com/api/v2/"
  @prices_url @base_url <> "stats/prices/"

  def get_prices(_items) do
    url = @prices_url <> "T4_BAG"

    HTTPoison.get(url)
    |> handle_response()
  end

  defp handle_response({:ok, response}), do: response.body

  # defp handle_response({:error, response}), do: #TODO
end
