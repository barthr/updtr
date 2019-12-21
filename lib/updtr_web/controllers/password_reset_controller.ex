defmodule UpdtrWeb.PasswordResetController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts

  require Logger

  action_fallback UpdtrWeb.FallbackController

  def request_reset_password(conn, %{"email" => email}) do
    Accounts.request_password_reset(email)

    conn
    |> send_resp(204, "")
  end

  def reset_password(conn, %{"token" => token, "new_password" => new_password}) do
    with {:ok, user} <- Accounts.reset_password(token, new_password) do
      conn
      |> put_status(:ok)
      |> put_view(UpdtrWeb.UserView)
      |> render("show.json", user: user)
    end
  end
end
