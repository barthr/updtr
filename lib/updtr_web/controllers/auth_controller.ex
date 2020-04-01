defmodule UpdtrWeb.AuthController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts
  alias UpdtrWeb.Auth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back #{user.email}")
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, :email_not_validated} ->
        conn
        |> put_flash(:error, "Validate your email before logging in")
        |> redirect(to: Routes.auth_path(conn, :new))

      {:error, _} ->
        conn
        |> put_flash(:error, "Wrong email/password combination")
        |> redirect(to: Routes.auth_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> put_flash(:info, "Successfully logged out")
    |> clear_session()
    |> redirect(to: Routes.auth_path(conn, :new))
  end
end
