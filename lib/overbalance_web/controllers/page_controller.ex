defmodule OverbalanceWeb.PageController do
  use OverbalanceWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def playtimes(conn, %{"btag" => btag}) do
    playtimes = Overbalance.Fetcher.fetch(btag)
    json conn, playtimes
  end
end
