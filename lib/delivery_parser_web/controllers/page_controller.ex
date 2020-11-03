defmodule DeliveryParserWeb.PageController do
  use DeliveryParserWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
