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
    {:ok, assign(socket, user_id: id, bookmarks: bookmarks, changeset: Bookmarks.change_mark(%Mark{}))}
  end

  def handle_event("create", %{"mark" => mark_params}, socket) do
    params =
      %{"user_id" => socket.assigns.user_id}
      |> Map.merge(mark_params)

    case Bookmarks.create_mark(params) do
      {:ok, bookmark} ->
        bookmarks = [bookmark | socket.assigns.bookmarks]
        {
          :noreply,
          socket
          |> put_flash(:info, "Mark created successfully.")
          |> assign(bookmarks: bookmarks)
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, %{changeset: changeset})}

      {:error, error} ->
        {
          :noreply,
          socket
          |> put_flash(:error, error)
        }
    end
  end

  def handle_event("search", %{"search_field" => %{"query" => query}}, socket) do
    if query == "" do
        {:noreply, assign(socket, bookmarks: Bookmarks.list_bookmarks(socket.assigns.user_id))}
    else
      bookmarks = Bookmarks.search(socket.assigns.user_id, query)
      {:noreply, assign(socket, bookmarks: bookmarks)}
    end
  end
end
