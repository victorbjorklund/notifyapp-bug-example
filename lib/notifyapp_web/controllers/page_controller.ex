defmodule NotifyappWeb.PageController do
  use NotifyappWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
