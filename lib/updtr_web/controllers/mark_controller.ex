defmodule UpdtrWeb.MarkController do
  use UpdtrWeb, :controller

  alias Updtr.Bookmarks
  alias Updtr.Bookmarks.Mark

  def index(conn, _params) do
    bookmarks = Bookmarks.list_bookmarks(conn.assigns.current_user.id)
    render(conn, "index.html", bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = Bookmarks.change_mark(%Mark{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"mark" => mark_params}) do
    case Bookmarks.create_mark(mark_params) do
      {:ok, mark} ->
        conn
        |> put_flash(:info, "Mark created successfully.")
        |> redirect(to: Routes.mark_path(conn, :show, mark))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    mark = Bookmarks.get_mark!(id)
    render(conn, "show.html", mark: mark)
  end

  def edit(conn, %{"id" => id}) do
    mark = Bookmarks.get_mark!(id)
    changeset = Bookmarks.change_mark(mark)
    render(conn, "edit.html", mark: mark, changeset: changeset)
  end

  def update(conn, %{"id" => id, "mark" => mark_params}) do
    mark = Bookmarks.get_mark!(id)

    case Bookmarks.update_mark(mark, mark_params) do
      {:ok, mark} ->
        conn
        |> put_flash(:info, "Mark updated successfully.")
        |> redirect(to: Routes.mark_path(conn, :show, mark))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", mark: mark, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    mark = Bookmarks.get_mark!(id)
    {:ok, _mark} = Bookmarks.delete_mark(mark)

    conn
    |> put_flash(:info, "Mark deleted successfully.")
    |> redirect(to: Routes.mark_path(conn, :index))
  end
end