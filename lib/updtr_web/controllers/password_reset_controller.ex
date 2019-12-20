defmodule UpdtrWeb.PasswordResetController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts

  require Logger

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

  def handle_reset_password(conn, _params) do
    conn
  end
end
