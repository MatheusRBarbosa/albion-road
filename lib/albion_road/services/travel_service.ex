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
          city: String.downcase(item["city"]),
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
      |> Enum.chunk_every(2)
      |> Enum.map(fn item_pair ->
        order_by_city(List.first(item_pair), List.last(item_pair), cities)
      end)
      |> Enum.map(fn item_pair -> filter_item_pair(item_pair) end)
      |> Enum.filter(&(!is_nil(&1)))
      |> Enum.map(fn item_pair -> calc_profit(item_pair) end)
      |> Enum.sort(&(&1.avg_profit >= &2.avg_profit))
      |> Enum.take(20)

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

  defp order_by_city(
         %PricesStruct{} = first_item,
         %PricesStruct{} = second_item,
         %TravelStruct{} = cities
       )
       when first_item.city == cities.from,
       do: [first_item, second_item]

  defp order_by_city(
         %PricesStruct{} = first_item,
         %PricesStruct{} = second_item,
         %TravelStruct{} = cities
       )
       when second_item.city == cities.from,
       do: [second_item, first_item]

  defp filter_item_pair(item_pair) do
    %PricesStruct{} = first = List.first(item_pair)
    %PricesStruct{} = last = List.last(item_pair)
    filter_zero_values(first, last)
  end

  defp calc_profit(item_pair) do
    %PricesStruct{} = first = List.first(item_pair)
    %PricesStruct{} = last = List.last(item_pair)
    parse_item_avg(first, last)
  end

  defp parse_item_avg(%PricesStruct{} = item_from, %PricesStruct{} = item_to) do
    avg_profit = item_to.sell_price_max - item_from.buy_price_max

    %ItemsAvgStruct{
      item_id: item_from.item_id,
      avg_buy_price: item_from.buy_price_max,
      avg_sell_price: item_to.sell_price_max,
      avg_profit: avg_profit,
      buy_in: item_from.city,
      sell_in: item_to.city
    }
  end

  defp handle_cities(from, to) when from != nil and to != nil,
    do: {:ok, %TravelStruct{from: from, to: to}}

  defp handle_cities(from, to) when from == nil or to == nil,
    do: {:error, %TravelStruct{from: from, to: to}}

  defp filter_zero_values(%PricesStruct{} = first, %PricesStruct{} = last)
       when first.buy_price_min > 1 and
              first.buy_price_max > 1 and
              last.sell_price_min > 1 and
              last.sell_price_max > 2,
       do: [first, last]

  defp filter_zero_values(%PricesStruct{} = _first, %PricesStruct{} = _last), do: nil
end
