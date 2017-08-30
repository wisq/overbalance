defmodule OverbalanceWeb.PageControllerTest do
  use OverbalanceWeb.ConnCase
  import Mock

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Zenyatta"
  end

  @test_html ~s"""
<div id="quickplay">
  <div data-category-id="overwatch.guid.0x0860000000000021">
    <div class="bar-text">
      <div class="title">Mei</div>
      <div class="description">1 hour</div>
    </div>
    <div class="bar-text">
      <div class="title">D.Va</div>
      <div class="description">2 hours</div>
    </div>
  </div>
</div>
<div id="competitive">
  <div data-category-id="overwatch.guid.0x0860000000000021">
    <div class="bar-text">
      <div class="title">Zarya</div>
      <div class="description">4 minutes</div>
    </div>
    <div class="bar-text">
      <div class="title">Winston</div>
      <div class="description">4 seconds</div>
    </div>
  </div>
</div>
"""
  @test_data %{
    "quickplay" => %{
      "Mei"  => 1*3600,
      "D.Va" => 2*3600,
    },
    "competitive" => %{
      "Zarya"   => 4*60,
      "Winston" => 4,
    },
  }

  test "GET /playtimes", %{conn: conn} do
    url = "https://playoverwatch.com/en-us/career/pc/us/xyz-321"
    with_mock Overbalance.Fetcher.Request, [get: fn(^url) -> @test_html end] do
      conn = get conn, "/playtimes?btag=xyz%23321"
      assert json_response(conn, 200) == @test_data
      assert called Overbalance.Fetcher.Request.get(url)
    end
  end
end
