defmodule Updtr.Accounts do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Updtr.Repo

  alias Updtr.Accounts.User
  alias Updtr.Accounts.PasswordReset

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def authenticate_user(email, password) do
    query = from(u in User, where: u.email == ^email)
    query |> Repo.one() |> verify_password(password)
  end

  defp verify_password(nil, _) do
    # Perform a dummy check to make user enumeration more difficult
    Bcrypt.no_user_verify()
    {:error, "Wrong email or password"}
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Wrong email or password"}
    end
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  def request_password_reset(email) do
    reset_token = random_string(24)

    case Repo.one(from u in User, where: u.email == ^email) do
      nil ->
        {:error, "request email #{email} not found"}

      user ->
        %PasswordReset{}
        |> PasswordReset.changeset(%{user_id: user.id, password_reset_token: reset_token})
        |> Repo.insert()
        |> send_password_reset_mail
    end
  end

  defp send_password_reset_mail({:ok, %PasswordReset{user_id: id, password_reset_token: token}}) do
    user = get_user!(id)

    with Updtr.Mailer.reset_password(user.email, token) do
      {:ok, :email_send}
    end
  end

  defp send_password_reset_mail({:error, _message}) do
    {:ok, :email_send}
  end

  defp update_user_password(nil, _new_password) do
    {:error, "invalid reset token"}
  end

  defp update_user_password(%PasswordReset{reset_token_used: true}, _new_password) do
    {:error, "reset token is already used"}
  end

  defp update_user_password(%PasswordReset{} = reset_password, new_password) do
    Repo.transaction(fn ->
      reset_password
      |> PasswordReset.changeset(%{reset_token_used: true})
      |> Repo.update()

      reset_password.user
      |> update_user(%{password: new_password})
    end)
  end

  def reset_password(reset_token, new_password) do
    query =
      from p in PasswordReset,
        where: p.password_reset_token == ^reset_token,
        where: p.valid_until > ^DateTime.utc_now(),
        preload: [:user],
        select: p

    Repo.one(query)
    |> update_user_password(new_password)
  end
end
