defmodule AlbionRoad.Services.TravelService do
  alias AlbionRoad.Structs.{PricesStruct, TravelStruct}
  alias AlbionRoad.Services.HttpService
  alias AlbionRoad.Helpers.MappableHelper

  @cities [
    %{"id" => 1, "name" => "thetford"},
    %{"id" => 2, "name" => "fortsterling"},
    %{"id" => 3, "name" => "lymhurst"},
    %{"id" => 4, "name" => "bridgewatch"},
    %{"id" => 5, "name" => "martlock"},
    %{"id" => 6, "name" => "caerleon"}
  ]

  def handle_params(%{"from" => from, "to" => to}) do
    from_city = from |> String.trim() |> Integer.parse() |> find_city(from)
    to_city = to |> String.trim() |> Integer.parse() |> find_city(to)

    handle_cities(from_city, to_city)
  end

  def call(%TravelStruct{} = cities, items) do
    # TODO: converter string json para struct corretamente
    response = HttpService.get_prices(items)
    {:ok, response}
  end

  defp find_city(id, param) when :error == id do
    city = Enum.find(@cities, fn city -> city["name"] == param end)
    city["name"]
  end

  defp find_city(value, _param) do
    id = elem(value, 0)
    city = Enum.find(@cities, fn city -> city["id"] == id end)
    city["name"]
  end

  defp handle_cities(from, to) when from != nil and to != nil,
    do: {:ok, %TravelStruct{from: from, to: to}}

  defp handle_cities(from, to) when from == nil or to == nil,
    do: {:error, %TravelStruct{from: from, to: to}}
end
