defmodule AlbionRoad.Services.Travel do
  @cities [
    %{"id" => 1, "name" => "thetford"},
    %{"id" => 2, "name" => "fortsterling"},
    %{"id" => 3, "name" => "lymhurst"},
    %{"id" => 4, "name" => "bridgewatch"},
    %{"id" => 5, "name" => "martlock"},
    %{"id" => 6, "name" => "caerleon"}
  ]

  def call(%{"from" => from, "to" => to}) do
    from_city = from |> String.trim() |> Integer.parse() |> find_city(from)
    to_city = to |> String.trim() |> Integer.parse() |> find_city(to)

    handle_cities(from_city, to_city)
  end

  defp find_city(id, param) when :error == id do
    city_name = param |> String.downcase()
    city = Enum.find(@cities, fn city -> city["name"] == param end)
    city["name"]
  end

  defp find_city(value, _param) do
    id = elem(value, 0)
    city = Enum.find(@cities, fn city -> city["id"] == id end)
    city["name"]
  end

  defp handle_cities(from, to) when from != nil and to != nil do
    %{"from" => from, "to" => to}
  end

  defp handle_cities(from, to) when from == nil and to == nil,
    do: %{"from" => "From city not found", "to" => "To city not found"}

  defp handle_cities(from, to) when from == nil,
    do: %{"from" => "From city not found", "to" => to}

  defp handle_cities(from, to) when to == nil,
    do: %{"from" => from, "to" => "To city not found"}
end
