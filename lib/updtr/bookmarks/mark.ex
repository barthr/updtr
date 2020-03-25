defmodule Updtr.Bookmarks.Mark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Updtr.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bookmarks" do
    field :content, :string
    field :hashed_url, :string
    field :title, :string
    field :url, :string

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(mark, attrs) do
    mark
    |> cast(attrs, [:title, :url, :hashed_url, :content, :user_id])
    |> foreign_key_constraint(:user_id)
    |> validate_required([:title, :url, :hashed_url, :content])
  end
end
