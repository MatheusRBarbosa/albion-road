defmodule AlbionRoad.Structs.ItemsAvgStruct do
  @derive Jason.Encoder
  defstruct item_id: "",
            avg_buy_price_from_city: 0,
            avg_sell_price_to_city: 0,
            avg_profit: 0,
            buy_in: "",
            sell_in: ""
end
