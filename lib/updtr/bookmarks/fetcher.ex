defmodule Updtr.Bookmarks.Fetcher do
  alias Updtr.HTTPClient
  alias Updtr.Bookmarks.Mark
  alias Updtr.Image.Transformer


  def fetch(attrs) do
    case HTTPClient.get(attrs.url) do
      {:ok, response} ->
        html = Floki.parse_document!(response.body)

        resp =
          Map.put(attrs, :content, Floki.raw_html(html))
          |> extract_title(html)
          |> extract_description(html)
#          |> extract_image(html)

        {:ok, resp}
      {:error, error} ->
        {:error, error}
    end
  end

  defp extract_title(mark, content) do
    title =
      content
      |> Floki.find("title")
      |> Floki.text()
      |> String.split("-")
      |> List.first()

    Map.put(mark, :title, title)
  end

  defp extract_description(mark, content) do
    description =
      content
      |> Floki.find(~s(meta[name="description"]))
      |> List.last
      |> Floki.attribute("content")
      |> Floki.text

    Map.put(mark, :description, description)
  end

  defp extract_image(mark, content) do
    image_href =
      content
      |> Floki.find(~s(meta[property="og:image"]))

    case image_href do
      [] ->
        mark
      href ->
        static_image_path =
          Floki.attribute(href, "content")
          |> store_image(mark.hashed_url)

        Map.put(mark, :thumbnail, static_image_path)
    end
  end

  defp store_image(url, file_name) do
    static_path = Application.get_env(:updtr, :media_path)
    {:ok, response} = HTTPClient.get(url)

    path = "#{static_path}/thumbnail_#{file_name}.jpeg"
    with :ok <- File.mkdir_p(Path.dirname(path)) do
      File.write(path, response.body)
      Transformer.transform(path)
    end

    path
  end
end
