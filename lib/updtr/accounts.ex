defmodule Updtr.Accounts do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Updtr.Repo
  alias Ecto.Multi

  alias Updtr.Accounts.User
  alias Updtr.Accounts.PasswordReset

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_password_reset_by_token(reset_token) do
    query =
      from p in PasswordReset,
        where: p.password_reset_token == ^reset_token,
        where: p.valid_until > ^DateTime.utc_now(),
        where: not p.reset_token_used,
        preload: [:user],
        select: p

    Repo.one(query)
  end

  def sign_up(email, password) do
    activation_token = random_string(32)

    user_changeset =
      %User{}
      |> User.changeset(%{
        email: email,
        password: password,
        activation_token: activation_token
      })

    Multi.new()
    |> Multi.insert(:user, user_changeset)
    |> Multi.run(:verification_mail, fn _repo, %{user: user} ->
      with _value <- Updtr.Mailer.registration_mail(user.email, activation_token) do
        {:ok, "Check your email"}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _rest} ->
        {:ok, "Check your email"}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  def validate_email(token) do
    query =
      from u in User,
        where: u.activation_token == ^token

    Repo.one(query)
    |> set_email_validated()
  end

  defp set_email_validated(nil) do
    {:error, :invalid_token}
  end

  defp set_email_validated(user) do
    user
    |> User.activation_changeset(%{email_validated: true, activation_token: nil})
    |> Repo.update()
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
    reset_token = random_string(32)

    case Repo.one(from u in User, where: u.email == ^email) do
      nil ->
        {:error, "request email #{email} not found"}

      user ->
        Multi.new()
        |> Multi.insert(
          :password_reset,
          PasswordReset.changeset(%PasswordReset{}, %{
            user_id: user.id,
            password_reset_token: reset_token
          })
        )
        |> Multi.run(:send_password_reset_mail, fn _repo, %{password_reset: password_reset} ->
          user = get_user!(password_reset.user_id)

          reset_token = password_reset.password_reset_token

          with Updtr.Mailer.reset_password(user.email, reset_token) do
            {:ok, "check your email"}
          end
        end)
        |> Repo.transaction()
    end
  end

  defp update_user_password(nil, _new_password) do
    {:error, "Invalid reset token"}
  end

  defp update_user_password(%PasswordReset{reset_token_used: true}, _new_password) do
    {:error, "Reset token is already used"}
  end

  defp update_user_password(%PasswordReset{} = reset_password, new_password) do
    statements =
      Multi.new()
      |> Multi.update(
        :password_reset,
        PasswordReset.changeset(reset_password, %{reset_token_used: true})
      )
      |> Multi.update(:user, User.changeset(reset_password.user, %{password: new_password}))

    case Repo.transaction(statements) do
      {:ok, %{user: user, password_reset: _reset}} ->
        {:ok, user}

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        {:error, failed_value}
    end
  end

  def reset_password(reset_token, new_password) do
    get_password_reset_by_token(reset_token)
    |> update_user_password(new_password)
  end
end
