defmodule AlbionRoadWeb.PageController do
  use AlbionRoadWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
