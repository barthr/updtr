defmodule UpdtrWeb.LayoutView do
  use UpdtrWeb, :view

  alias UpdtrWeb.Auth

  def authenticated?(conn) do
    Auth.Guardian.Plug.authenticated?(conn)
  end
end
