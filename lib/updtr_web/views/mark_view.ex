defmodule UpdtrWeb.MarkView do
  use UpdtrWeb, :view

  def random_color() do
    [
      "red", "orange", "yellow", "olive", "green",
      "teal", "blue", "violet", "purple", "pink",
      "brown", "grey", "black"
    ] |> Enum.random()
  end
end
