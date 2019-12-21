defmodule UpdtrWeb.Router do
  use UpdtrWeb, :router

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug UpdtrWeb.Auth.Pipeline
    plug UpdtrWeb.ValidateEmailPlug
  end

  scope "/api", UpdtrWeb do
    pipe_through [:api]
    post "/users/login", UserController, :sign_in
    post "/users/signup", UserController, :sign_up
    get "/users/verify-email", UserController, :activate_user

    post "/users/request-password-reset", PasswordResetController, :request_reset_password
    post "/users/reset-password", PasswordResetController, :reset_password
  end

  scope "/api", UpdtrWeb do
    pipe_through [:api, :auth]
    resources "/users", UserController, except: [:new, :edit]
  end
end
