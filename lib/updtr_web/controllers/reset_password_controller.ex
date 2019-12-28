defmodule UpdtrWeb.ResetPasswordController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts
  alias Updtr.Accounts.PasswordReset

  def new(conn, _) do
    conn
    |> render("new.html")
  end

  def show(conn, params) do
    edit(conn, params)
  end

  def edit(conn, %{"token" => token}) do
    case Accounts.get_password_reset_by_token(token) do
      nil ->
        conn
        |> put_flash(:error, "Reset token not found")
        |> redirect(to: Routes.auth_path(conn, :new))

      password_reset ->
        conn
        |> render("edit.html",
          password_reset: password_reset,
          changeset: PasswordReset.changeset(password_reset)
        )
    end
  end

  def create(conn, %{"reset_password" => %{"email" => email}}) do
    Accounts.request_password_reset(email)

    conn
    |> put_flash(:info, "Password reset requested, see your mail for instructions")
    |> redirect(to: Routes.auth_path(conn, :new))
  end

  def update(conn, %{
        "password_reset" => password_reset_params
      }) do
    if password_reset_params["password"] != password_reset_params["password_confirm"] do
      conn
      |> put_flash(:error, "Passwords should match!")
      |> redirect(
        to:
          Routes.reset_password_path(conn, :edit,
            token: password_reset_params["password_reset_token"]
          )
      )
    else
      password_reset =
        Accounts.get_password_reset_by_token(password_reset_params["password_reset_token"])

      case Accounts.reset_password(
             password_reset,
             Map.put(password_reset_params, "reset_token_used", true)
           ) do
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", changeset: changeset, password_reset: password_reset)

        {:error, message} ->
          conn
          |> put_flash(:error, message)
          |> redirect(to: Routes.auth_path(conn, :new))

        {:ok, _message} ->
          conn
          |> put_flash(:info, "Updated password")
          |> redirect(to: Routes.auth_path(conn, :new))
      end
    end
  end
end
