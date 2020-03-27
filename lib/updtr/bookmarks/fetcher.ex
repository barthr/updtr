defmodule Updtr.Bookmarks.Fetcher do
  alias Updtr.HTTPClient


  def fetch(url) do
    case HTTPClient.get(url) do
      {:ok, response} ->
        Floki.find(response.body, ~s(meta[name="description"]))
        |> IO.inspect

        Floki.find(response.body, "title")
        |> IO.inspect
      {:error, error} ->
        IO.puts(error)
    end
  end
end
