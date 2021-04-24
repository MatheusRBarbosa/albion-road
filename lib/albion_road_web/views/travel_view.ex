defmodule  AlbionRoadWeb.TravelView do
  use AlbionRoadWeb, :view

  def render("travel.json", %{params: params}) do
    %{params: params}
  end
end
