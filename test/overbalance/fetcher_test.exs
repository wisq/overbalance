defmodule Overbalance.FetcherTest do
  use ExUnit.Case, async: true

  alias Overbalance.Fetcher

  test "generates correct URL" do
    assert Fetcher.get_overwatch_url("Wisq#11523") ==
      "https://playoverwatch.com/en-us/career/pc/us/Wisq-11523"
    assert Fetcher.get_overwatch_url("ŁIŦERAŁ#1234") ==
      "https://playoverwatch.com/en-us/career/pc/us/ŁIŦERAŁ-1234"
  end

  @basic_quickplay_html ~s"""
<div id="quickplay">
  <div data-category-id="overwatch.guid.0x0860000000000021">
    <div class="bar-text">
      <div class="title">Hanzo</div>
      <div class="description">999 hours</div> <!-- I hate myself -->
    </div>
    <div class="bar-text">
      <div class="title">Widowmaker</div>
      <div class="description">9999 hours</div> <!-- kill me now -->
    </div>
  </div>
</div>
  """
  @basic_quickplay_data [
    {"Hanzo", 999*3600},
    {"Widowmaker", 9999*3600},
  ]

  @basic_competitive_html ~s"""
<div id="competitive">
  <div data-category-id="overwatch.guid.0x0860000000000021">
    <div class="bar-text">
      <div class="title">Lúcio</div>
      <div class="description">40 minutes</div> <!-- I'm helping! -->
    </div>
    <div class="bar-text">
      <div class="title">Mercy</div>
      <div class="description">1 second</div> <!-- changed my mind-->
    </div>
  </div>
</div>
"""
  @basic_competitive_data [
    {"Lúcio", 40*60},
    {"Mercy", 1},
  ]


  test "can process basic HTML" do
    assert Fetcher.extract_playtimes(@basic_quickplay_html <> @basic_competitive_html) ==
      [quickplay: @basic_quickplay_data, competitive: @basic_competitive_data]
  end

  test "can handle missing data" do
    assert Fetcher.extract_playtimes(@basic_quickplay_html) ==
      [quickplay: @basic_quickplay_data, competitive: []]
    assert Fetcher.extract_playtimes(@basic_competitive_html) ==
      [quickplay: [], competitive: @basic_competitive_data]
  end

  # Snapshot as of 2017-08-29 00:28 EDT.
  @real_data [
    quickplay: [
      {"Mei",         51*3600}, # hours
      {"Zarya",       46*3600},
      {"Lúcio",       39*3600},
      {"Symmetra",    30*3600},
      {"D.Va",        28*3600},
      {"Genji",       26*3600},
      {"McCree",      23*3600},
      {"Torbjörn",    21*3600},
      {"Junkrat",     19*3600},
      {"Roadhog",     18*3600},
      {"Mercy",       17*3600},
      {"Zenyatta",    17*3600},
      {"Tracer",      15*3600},
      {"Reinhardt",   13*3600},
      {"Sombra",      13*3600},
      {"Ana",         12*3600},
      {"Reaper",      11*3600},
      {"Doomfist",     9*3600},
      {"Winston",      9*3600},
      {"Hanzo",        9*3600},
      {"Soldier: 76",  8*3600},
      {"Bastion",      7*3600},
      {"Widowmaker",   6*3600},
      {"Pharah",       6*3600},
      {"Orisa",        3*3600},
    ], competitive: [
      {"Lúcio",    48*60}, # minutes
      {"Mei",      44*60},
      {"D.Va",     17*60},
      {"Zarya",     7*60},
      {"Zenyatta",  6*60},
      {"Symmetra",  4*60},
      {"Reaper",    3*60},
      {"McCree",    3*60},
      {"Roadhog",     32}, # seconds
      {"Soldier: 76", 30},
      {"Winston",     25},
      {"Tracer",       0},
      {"Mercy",        0},
      {"Hanzo",        0},
      {"Torbjörn",     0},
      {"Reinhardt",    0},
      {"Pharah",       0},
      {"Widowmaker",   0},
      {"Bastion",      0},
      {"Genji",        0},
      {"Junkrat",      0},
      {"Sombra",       0},
      {"Doomfist",     0},
      {"Ana",          0},
      {"Orisa",        0},
    ]
  ]

  # Parsing this much HTML is expensive,
  # so I only have one test case for real data.
  test "can process real HTML" do
    html = File.read!("test/data/wisq-11523.html")
    assert Fetcher.extract_playtimes(html) == @real_data
  end
end
