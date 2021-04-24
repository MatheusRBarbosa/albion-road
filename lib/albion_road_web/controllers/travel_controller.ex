defmodule AlbionRoadWeb.TravelController do
  use AlbionRoadWeb, :controller

  action_fallback FallbackController

  def show(conn, params) do
    conn
    |> put_status(:ok)
    |> render("travel.json", params: params)
  end
end
