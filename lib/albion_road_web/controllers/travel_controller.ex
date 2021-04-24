defmodule AlbionRoadWeb.TravelController do
  use AlbionRoadWeb, :controller

  alias AlbionRoad.Services.Travel

  def show(conn, params) do
    with {:ok, body} <- File.read("priv/data/items.json"),
         {:ok, _json} <- Jason.decode(body) do
      response = Travel.call(params)

      conn
      |> put_status(:ok)
      |> render("travel.json", json: response)
    end
  end
end
