defmodule UpdtrWeb.PasswordResetController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts

  require Logger

  action_fallback UpdtrWeb.FallbackController

  def request_reset_password(conn, %{"email" => email}) do
    case Accounts.request_password_reset(email) do
      {:error, message} ->
        Logger.error("failed request password reset: #{message}")

      {:ok, :email_send} ->
        nil
    end

    conn
    |> send_resp(204, "")
  end

  def reset_password(conn, %{"token" => token, "new_password" => new_password}) do
    case Accounts.reset_password(token, new_password) do
      {:ok, user} ->
        conn
        |> put_status(:ok)
        |> put_view(UpdtrWeb.UserView)
        |> render("show.json", user: user)

      {:error, %Ecto.Changeset{} = changeset} ->
        {:error, changeset}

      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> render("token_error.json", message: message)
    end
  end
end
