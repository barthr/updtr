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
  end

  scope "/api", UpdtrWeb do
    pipe_through [:api]
    post "/users/login", UserController, :sign_in
    post "/users/reset-password", PasswordResetController, :request_reset_password
  end

  scope "/api", UpdtrWeb do
    pipe_through [:api, :auth]
    resources "/users", UserController, except: [:new, :edit]
  end
end
