defmodule UpdtrWeb.UserController do
  use UpdtrWeb, :controller

  alias Updtr.Auth
  alias UpdtrWeb.Auth
  alias Updtr.Accounts
  alias Updtr.Accounts.User

  require Logger

  plug :authenticate_valid_action when action in [:show, :update, :delete]

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
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

  def sign_up(conn, %{"email" => email, "password" => password}) do
    with {:ok, _message} <- Accounts.sign_up(email, password) do
      conn
      |> put_status(:created)
      |> render("sign_up.json", message: "Succesfully signed up, see your email for instructions")
    end
  end

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
