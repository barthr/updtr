defmodule Updtr.Bookmarks do
  @moduledoc """
  The Bookmarks context.
  """

  import Ecto.Query, warn: false
  alias Updtr.Repo

  alias Updtr.Bookmarks.{Mark, Fetcher}

  @doc """
  Returns the list of bookmarks.

  ## Examples

      iex> list_bookmarks()
      [%Mark{}, ...]

  """
  def list_bookmarks(id) do
    Mark
    |> where(user_id: ^id)
    |> Repo.all()
  end

  @doc """
  Gets a single mark.

  Raises `Ecto.NoResultsError` if the Mark does not exist.

  ## Examples

      iex> get_mark!(123)
      %Mark{}

      iex> get_mark!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mark!(id), do: Repo.get!(Mark, id)

  @doc """
  Creates a mark.

  ## Examples

      iex> create_mark(%{field: value})
      {:ok, %Mark{}}

      iex> create_mark(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mark(attrs \\ %{}) do
    mark = %Mark{}
           |> Mark.changeset(attrs)
           |> Repo.insert()

    {:ok, %{url: url}} = mark
    Fetcher.fetch(url)
    mark
  end

  @doc """
  Updates a mark.

  ## Examples

      iex> update_mark(mark, %{field: new_value})
      {:ok, %Mark{}}

      iex> update_mark(mark, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mark(%Mark{} = mark, attrs) do
    mark
    |> Mark.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Mark.

  ## Examples

      iex> delete_mark(mark)
      {:ok, %Mark{}}

      iex> delete_mark(mark)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mark(%Mark{} = mark) do
    Repo.delete(mark)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mark changes.

  ## Examples

      iex> change_mark(mark)
      %Ecto.Changeset{source: %Mark{}}

  """
  def change_mark(%Mark{} = mark) do
    Mark.changeset(mark, %{})
  end
end
