defmodule UpdtrWeb.Router do
  use UpdtrWeb, :router

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug UpdtrWeb.Auth.Pipeline
    plug UpdtrWeb.ValidateEmailPlug
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", UpdtrWeb do
    pipe_through [:browser]

    get "/", PageController, :index

    resources "/auth", AuthController, only: [:new, :create], singleton: true

    # post "/users/login", UserController, :sign_in
    # post "/users/signup", UserController, :sign_up
    # get "/users/verify-email", UserController, :activate_user
    # put "/users/resend-verification-email", UserController, :resend_verification

    # post "/users/request-password-reset", PasswordResetController, :request_reset_password
    # post "/users/reset-password", PasswordResetController, :reset_password
  end

  scope "/api", UpdtrWeb do
    pipe_through [:browser, :auth]
    # resources "/users", UserController, except: [:new, :edit]
  end
end
