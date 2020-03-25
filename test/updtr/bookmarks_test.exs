defmodule Updtr.BookmarksTest do
  use Updtr.DataCase

  alias Updtr.Bookmarks

  describe "bookmarks" do
    alias Updtr.Bookmarks.Mark

    @valid_attrs %{content: "some content", hashed_url: "some hashed_url", title: "some title", url: "some url"}
    @update_attrs %{content: "some updated content", hashed_url: "some updated hashed_url", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{content: nil, hashed_url: nil, title: nil, url: nil}

    def mark_fixture(attrs \\ %{}) do
      {:ok, mark} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Bookmarks.create_mark()

      mark
    end

    test "list_bookmarks/0 returns all bookmarks" do
      mark = mark_fixture()
      assert Bookmarks.list_bookmarks() == [mark]
    end

    test "get_mark!/1 returns the mark with given id" do
      mark = mark_fixture()
      assert Bookmarks.get_mark!(mark.id) == mark
    end

    test "create_mark/1 with valid data creates a mark" do
      assert {:ok, %Mark{} = mark} = Bookmarks.create_mark(@valid_attrs)
      assert mark.content == "some content"
      assert mark.hashed_url == "some hashed_url"
      assert mark.title == "some title"
      assert mark.url == "some url"
    end

    test "create_mark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_mark(@invalid_attrs)
    end

    test "update_mark/2 with valid data updates the mark" do
      mark = mark_fixture()
      assert {:ok, %Mark{} = mark} = Bookmarks.update_mark(mark, @update_attrs)
      assert mark.content == "some updated content"
      assert mark.hashed_url == "some updated hashed_url"
      assert mark.title == "some updated title"
      assert mark.url == "some updated url"
    end

    test "update_mark/2 with invalid data returns error changeset" do
      mark = mark_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_mark(mark, @invalid_attrs)
      assert mark == Bookmarks.get_mark!(mark.id)
    end

    test "delete_mark/1 deletes the mark" do
      mark = mark_fixture()
      assert {:ok, %Mark{}} = Bookmarks.delete_mark(mark)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_mark!(mark.id) end
    end

    test "change_mark/1 returns a mark changeset" do
      mark = mark_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_mark(mark)
    end
  end
end
