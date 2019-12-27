defmodule UpdtrWeb.UserController do
  use UpdtrWeb, :controller

  alias Updtr.Auth
  alias UpdtrWeb.Auth
  alias Updtr.Accounts
  alias Updtr.Accounts.User

  require Logger

  plug :authenticate_valid_action when action in [:show, :update, :delete]

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, _message} <- Accounts.sign_up(email, password) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", message: "Succesfully signed up, see your email for instructions")
    end
  end

  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Accounts.get_user!(id)

  #   with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
  #     render(conn, "show.json", user: user)
  #   end
  # end

  def activate_user(conn, %{"token" => token}) do
    with {:ok, user} <- Accounts.validate_email(token) do
      conn
      |> put_status(:ok)
      |> render("show.json", user: user)
    end
  end

  defp authenticate_valid_action(conn, _) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.id == conn.params["id"] do
      conn
    else
      conn
    end
  end
end
