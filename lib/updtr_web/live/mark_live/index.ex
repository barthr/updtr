defmodule UpdtrWeb.MarkLive.Index do
  use Phoenix.LiveView, layout: {UpdtrWeb.LayoutView, "live.html"}

  alias UpdtrWeb.MarkView
  alias Updtr.Bookmarks
  alias Updtr.Bookmarks.Mark

  def render(assigns) do
    MarkView.render("index.html", assigns)
  end

  def mount(_params, %{"user_id" => id}, socket) do
    bookmarks = Bookmarks.list_bookmarks(id)
    {:ok, assign(socket, bookmarks: bookmarks, changeset: Bookmarks.change_mark(%Mark{}))}
  end
end
