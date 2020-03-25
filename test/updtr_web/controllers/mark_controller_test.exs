defmodule UpdtrWeb.MarkControllerTest do
  use UpdtrWeb.ConnCase

  alias Updtr.Bookmarks

  @create_attrs %{content: "some content", hashed_url: "some hashed_url", title: "some title", url: "some url"}
  @update_attrs %{content: "some updated content", hashed_url: "some updated hashed_url", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{content: nil, hashed_url: nil, title: nil, url: nil}

  def fixture(:mark) do
    {:ok, mark} = Bookmarks.create_mark(@create_attrs)
    mark
  end

  describe "index" do
    test "lists all bookmarks", %{conn: conn} do
      conn = get(conn, Routes.mark_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Bookmarks"
    end
  end

  describe "new mark" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.mark_path(conn, :new))
      assert html_response(conn, 200) =~ "New Mark"
    end
  end

  describe "create mark" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.mark_path(conn, :create), mark: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.mark_path(conn, :show, id)

      conn = get(conn, Routes.mark_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Mark"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.mark_path(conn, :create), mark: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Mark"
    end
  end

  describe "edit mark" do
    setup [:create_mark]

    test "renders form for editing chosen mark", %{conn: conn, mark: mark} do
      conn = get(conn, Routes.mark_path(conn, :edit, mark))
      assert html_response(conn, 200) =~ "Edit Mark"
    end
  end

  describe "update mark" do
    setup [:create_mark]

    test "redirects when data is valid", %{conn: conn, mark: mark} do
      conn = put(conn, Routes.mark_path(conn, :update, mark), mark: @update_attrs)
      assert redirected_to(conn) == Routes.mark_path(conn, :show, mark)

      conn = get(conn, Routes.mark_path(conn, :show, mark))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, mark: mark} do
      conn = put(conn, Routes.mark_path(conn, :update, mark), mark: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Mark"
    end
  end

  describe "delete mark" do
    setup [:create_mark]

    test "deletes chosen mark", %{conn: conn, mark: mark} do
      conn = delete(conn, Routes.mark_path(conn, :delete, mark))
      assert redirected_to(conn) == Routes.mark_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.mark_path(conn, :show, mark))
      end
    end
  end

  defp create_mark(_) do
    mark = fixture(:mark)
    {:ok, mark: mark}
  end
end
