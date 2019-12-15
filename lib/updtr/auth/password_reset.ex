defmodule Updtr.Auth.PasswordReset do
  use Ecto.Schema
  import Ecto.Changeset

  alias Updtr.Auth.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "password_resets" do
    field :password_reset_token, :string
    field :valid_until, :naive_datetime

    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(verification, attrs) do
    verification
    |> cast(attrs, [:password_reset_token])
    |> foreign_key_constraint(:user)
    |> validate_required([:password_reset_token])
    |> unique_constraint(:password_reset_token)
  end
end
