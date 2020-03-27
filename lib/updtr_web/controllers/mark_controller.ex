defmodule UpdtrWeb.MarkController do
  use UpdtrWeb, :controller

  alias Updtr.Bookmarks
  alias Updtr.Bookmarks.Mark

  def index(conn, %{changeset: changeset}) do
    bookmarks = Bookmarks.list_bookmarks(conn.assigns.current_user.id)
    render(conn, "index.html", bookmarks: bookmarks, changeset: changeset)
  end

  def index(conn, _params) do
    index(conn, %{changeset: Bookmarks.change_mark(%Mark{})})
  end

  def create(conn, %{"mark" => mark_params}) do
    params =
      %{"hashed_url" => "test", "content" => "test", "title" => "test", "user_id" => conn.assigns.current_user.id}
      |> Map.merge(mark_params)

    case Bookmarks.create_mark(params) do
      {:ok, _ } ->
        conn
        |> put_flash(:info, "Mark created successfully.")
        |> redirect(to: Routes.mark_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        index(conn, %{changeset: changeset})
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
