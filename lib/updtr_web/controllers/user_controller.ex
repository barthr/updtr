defmodule UpdtrWeb.UserController do
  use UpdtrWeb, :controller

  alias Updtr.Auth
  alias UpdtrWeb.Auth
  alias Updtr.Accounts
  alias Updtr.Accounts.User

  require Logger

  action_fallback UpdtrWeb.FallbackController

  plug :authenticate_valid_action when action in [:show, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, token, user} <- Auth.Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render("sign_in.json", %{token: token, user: user})
    end
  end

  defp authenticate_valid_action(conn, _) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user.id == conn.params["id"] do
      conn
    else
      conn
      |> UpdtrWeb.FallbackController.call({:error, :unauthorized})
    end
  end
end
