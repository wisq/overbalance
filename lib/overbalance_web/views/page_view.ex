defmodule OverbalanceWeb.PageView do
  use OverbalanceWeb, :view

  def hero_data do
    # Hero select screen, left to right.
    [
      attack: [
        "Doomfist",
        "Genji",
        "McCree",
        "Pharah",
        "Reaper",
        "Soldier: 76",
        "Sombra",
        "Tracer",
      ],
      defense: [
        "Bastion",
        "Hanzo",
        "Junkrat",
        "Mei",
        "Torbjörn",
        "Widowmaker",
      ],
      tank: [
        "D.Va",
        "Orisa",
        "Reinhardt",
        "Roadhog",
        "Winston",
        "Zarya",
      ],
      support: [
        "Ana",
        "Lúcio",
        "Mercy",
        "Symmetra",
        "Zenyatta",
      ],
    ]
  end
end
