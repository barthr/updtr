defmodule UpdtrWeb.MarkView do
  use UpdtrWeb, :view

  def random_color() do
    [
      "red", "orange", "yellow", "olive", "green",
      "teal", "blue", "violet", "purple", "pink",
      "brown", "grey", "black"
    ] |> Enum.random()
  end

  def base_url(uri) do
    URI.parse(uri).authority
  end

  def show_date(timestamp) do
    Timex.format!(timestamp, "{D}-{M}-{YYYY}")
  end
end
