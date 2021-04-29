defmodule AlbionRoad.Structs.PricesStruct do
  @derive Jason.Encoder
  defstruct item_id: "",
            city: "",
            quality: 0,
            sell_price_min: 0,
            sell_price_min_date: "",
            sell_price_max: 0,
            sell_price_max_date: "",
            buy_price_min: 0,
            buy_price_min_date: "",
            buy_price_max: 0,
            buy_price_max_date: ""
end
