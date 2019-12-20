defmodule UpdtrWeb.Router do
  use UpdtrWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug UpdtrWeb.Auth.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", UpdtrWeb do
    pipe_through [:api]
    post "/users/login", UserController, :sign_in
  end

  scope "/api", UpdtrWeb do
    pipe_through [:api, :auth, :ensure_auth]
    resources "/users", UserController, except: [:new, :edit]
  end
end
