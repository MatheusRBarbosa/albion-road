defmodule AlbionRoad.Structs.ItemsAvgStruct do
  @derive Jason.Encoder
  defstruct item_id: "",
            avg_buy_price: 0,
            avg_sell_price: 0,
            avg_profit: 0,
            buy_in: "",
            sell_in: ""
end
