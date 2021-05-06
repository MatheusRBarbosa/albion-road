defmodule AlbionRoad.Services.TravelService do
  alias AlbionRoad.Structs.{ItemsAvgStruct, PricesStruct, TravelStruct}
  alias AlbionRoad.Services.HttpService

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
    result =
      HttpService.get_prices(cities, items)
      |> List.flatten()
      |> Enum.map(fn item ->
        %PricesStruct{
          item_id: item["item_id"],
          city: item["city"],
          quality: item["quality"],
          sell_price_min: item["sell_price_min"],
          sell_price_min_date: item["sell_price_min_date"],
          sell_price_max: item["sell_price_max"],
          sell_price_max_date: item["sell_price_max_date"],
          buy_price_min: item["buy_price_min"],
          buy_price_min_date: item["buy_price_min_date"],
          buy_price_max: item["buy_price_max"],
          buy_price_max_date: item["buy_price_max_date"]
        }
      end)
      |> calc_profit()
      |> Enum.filter(& !is_nil(&1))
      |> Enum.sort(&(&1.avg_profit >= &2.avg_profit))
      |> Enum.take(25)

    {:ok, result}
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

  defp calc_profit(items) do
    Enum.map(items, fn %PricesStruct{} = i -> find_pair_and_calc(items, i) end)
  end

  defp find_pair_and_calc(items, %PricesStruct{} = item) do
    pair_finded = Enum.find(items, fn %PricesStruct{} = i -> i.item_id == item.item_id end)
    if pair_finded != nil do
      avg_buy = (item.buy_price_min + item.buy_price_max)/2
      avg_sell = (pair_finded.sell_price_min + pair_finded.sell_price_max)/2

      if avg_buy != 0 and avg_sell != 0 do
        avg_profit = avg_sell - avg_buy
        %ItemsAvgStruct{
          item_id: item.item_id,
          avg_buy_price_from_city: avg_buy,
          avg_sell_price_to_city: avg_sell,
          avg_profit: avg_profit
        }
      end
    end
  end

  defp handle_cities(from, to) when from != nil and to != nil,
    do: {:ok, %TravelStruct{from: from, to: to}}

  defp handle_cities(from, to) when from == nil or to == nil,
    do: {:error, %TravelStruct{from: from, to: to}}
end
