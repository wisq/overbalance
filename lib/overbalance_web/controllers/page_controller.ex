defmodule OverbalanceWeb.PageController do
  use OverbalanceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
