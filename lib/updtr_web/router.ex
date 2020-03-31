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

  pipeline :auth do
    plug UpdtrWeb.Auth.Pipeline
  end

  pipeline :require_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", UpdtrWeb do
    pipe_through [:browser, :auth]

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
    pipe_through [:browser, :auth, :require_auth, :authenticate_user]

    get "/", PageController, :index

    resources "/users", UserController, except: [:new, :edit], singleton: true
    resources "/marks", MarkController

    live "/marks-live", MarkLive.Index
  end

  defp authenticate_user(conn, _) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> put_flash(:error, "Login required")
        |> redirect(to: "/login")
        |> halt()

      user ->
        assign(conn, :current_user, user)
    end
  end
end
