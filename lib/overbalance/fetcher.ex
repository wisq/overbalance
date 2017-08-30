defmodule Overbalance.Fetcher do
  defmodule Request do
    def get(url) do
      HTTPoison.get!(url).body
    end
  end


  def fetch(tag) do
    tag
    |> get_overwatch_url
    |> Request.get
    |> extract_playtimes
  end

  def get_overwatch_url(tag) do
    [name, number] = String.split(tag, "#", parts: 2)
    # FIXME add other regions, maybe platforms?
    "https://playoverwatch.com/en-us/career/pc/us/#{name}-#{number}"
  end

  def extract_playtimes(html) do
    [:quickplay, :competitive]
    |> Enum.map(fn(t) -> {t, extract_playtimes_for(t, html)} end)
    |> Map.new
  end

  @guid "overwatch.guid.0x0860000000000021"

  defp extract_playtimes_for(type, html) do
    html
    |> Floki.find(~s/##{type} *[data-category-id="#{@guid}"] .bar-text/)
    |> Enum.map(&character_playtime/1)
    |> Map.new
  end

  defp character_playtime(node) do
    {
      node |> Floki.find(".title") |> Floki.text,
      node |> Floki.find(".description") |> Floki.text |> playtime_seconds,
    } 
  end

  @time_units %{
    "second"  => 1,
    "seconds" => 1,
    "minute"  => 60,
    "minutes" => 60,
    "hour"    => 3600,
    "hours"   => 3600,
  }

  defp playtime_seconds("--"), do: 0
  defp playtime_seconds(text) do
    [number, unit] = String.split(text, " ", parts: 2)
    multiplier = Map.fetch!(@time_units, unit)
    String.to_integer(number) * multiplier
  end
end
