defmodule AlbionRoadWeb.TravelController do
  use AlbionRoadWeb, :controller

  def show(conn, _params) do
    with {:ok, body} <- File.read("priv/data/items.json"),
         {:ok, json} <- Jason.decode(body) do
      conn
      |> put_status(:ok)
      |> render("travel.json", json: json)
    end
  end
end
