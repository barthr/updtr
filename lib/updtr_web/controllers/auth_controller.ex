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
        |> Auth.Guardian.Plug.sign_in(user)
        |> redirect(to: "/")

      {:error, _} ->
        conn
        |> put_flash(:error, "Wrong email/password combination")
        |> redirect(to: Routes.auth_path(conn, :new))
    end
  end

  # def request_reset_password(conn, %{"email" => email}) do
  #   # Accounts.request_password_reset(email)

  #   conn
  #   |> send_resp(204, "")
  # end

  # def reset_password(conn, %{"token" => token, "new_password" => new_password}) do
  #   # with {:ok, user} <- Accounts.reset_password(token, new_password) do
  #   #   conn
  #   #   |> put_status(:ok)
  #   #   |> put_view(UpdtrWeb.UserView)
  #   #   |> render("show.json", user: user)
  #   # end
  # end
end
