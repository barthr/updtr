defmodule UpdtrWeb.LayoutView do
  use UpdtrWeb, :view
  use Phoenix.LiveView

  alias UpdtrWeb.Auth

  def authenticated?(conn) do
    Auth.Guardian.Plug.authenticated?(conn)
  end
end
