defmodule OverbalanceWeb.PageControllerTest do
  use OverbalanceWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Zenyatta"
  end
end
