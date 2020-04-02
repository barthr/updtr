defmodule UpdtrWeb.Router do
  use UpdtrWeb, :router
  import Phoenix.LiveView.Router

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {UpdtrWeb.LayoutView, :root}
  end

  scope "/", UpdtrWeb do
    pipe_through [:browser]

    resources "/auth", AuthController, only: [:create, :delete], singleton: true

    get "/login", AuthController, :new
    get "/sign-up", UserController, :new
    get "/activate", UserController, :activate_user
    get "/forgot-password", ResetPasswordController, :new

    resources "/reset-password", ResetPasswordController,
      only: [:create, :show, :edit, :update],
      singleton: true

    post "/users", UserController, :create
  end

  scope "/", UpdtrWeb do
    pipe_through [:browser, :authenticate_user]

    get "/", PageController, :index

    resources "/users", UserController, except: [:new, :edit], singleton: true

    live "/marks", MarkLive.Index
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_flash(:error, "Login required")
        |> redirect(to: "/login")
        |> halt()

      user_id ->
        assign(conn, :current_user, Updtr.Accounts.get_user!(user_id))
    end
  end
end
