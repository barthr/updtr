defmodule UpdtrWeb.UserController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts
  alias Updtr.Accounts.User

  alias UpdtrWeb.Auth

  require Logger

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "signup.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.sign_up(email, password) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Succesfully signed up, see your email for instructions")
        |> redirect(to: Routes.auth_path(conn, :new))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      {:error, message} ->
        Logger.error("failed signing up user with email #{email} because #{message}")

        conn
        |> put_status(:internal_server_error)
        |> put_flash(:error, "Unknown error when signing up")
        |> redirect(to: Routes.user_path(conn, :new))
    end
  end

  def activate_user(conn, %{"token" => token}) do
    case Accounts.validate_email(token) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Succesfully activated your account #{user.email}")
        |> redirect(to: "/")

      {:error, _message} ->
        conn
        |> put_flash(:error, "Invalid activation token")
        |> redirect(to: Routes.auth_path(conn, :new))
    end
  end
end
