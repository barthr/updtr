defmodule Updtr.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Updtr.Bookmarks.Mark

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :email_validated, :boolean, default: false
    field :password, :string, virtual: true
    field :password_hash, :string
    field :activation_token, :string


    has_many :bookmarks, Mark

    # Add support for microseconds at the language level
    # for this specific schema
    timestamps()
  end

  @doc false
  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password, :activation_token, :email_validated])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 10, max: 64)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def activation_changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :email, :email_validated, :activation_token])
    |> unique_constraint(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end
end
