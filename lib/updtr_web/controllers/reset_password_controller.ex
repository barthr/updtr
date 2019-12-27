defmodule UpdtrWeb.ResetPasswordController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts
  alias UpdtrWeb.Auth

  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def show(conn, %{"token" => token}) do
    case Accounts.get_password_reset_by_token(token) do
      nil ->
        conn
        |> put_flash(:error, "Reset token not found")
        |> redirect(to: Routes.auth_path(conn, :new))

      password_reset ->
        conn
        |> render("show.html", password_reset: password_reset)
    end
  end

  def create(conn, %{"reset_password" => %{"email" => email}}) do
    Accounts.request_password_reset(email)

    conn
    |> put_flash(:info, "Password reset requested, see your mail for instructions")
    |> redirect(to: Routes.auth_path(conn, :new))
  end

  def reset_password(conn, %{
        "password_reset" => %{
          "token" => token,
          "password" => password,
          "password_confirm" => password_confirm
        }
      }) do
    if password != password_confirm do
      conn
      |> put_flash(:error, "Passwords aren't the same")
      |> redirect(to: Routes.reset_password_path(conn, :show, token: token))
    else
      case Accounts.reset_password(token, password) do
        {:error, message} ->
          conn
          |> put_flash(:error, message)
          |> redirect(to: Routes.reset_password_path(conn, :show, token: token))

        {:ok, _message} ->
          conn
          |> put_flash(:info, "Updated password")
          |> redirect(to: Routes.auth_path(conn, :new))
      end
    end
  end
end
