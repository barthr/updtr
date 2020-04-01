defmodule UpdtrWeb.LayoutView do
  use UpdtrWeb, :view
  use Phoenix.LiveView

  alias UpdtrWeb.Auth

  def authenticated?(conn) do
    case Plug.Conn.get_session(conn, :user_id) do
      nil -> false
      _ -> true
    end
  end
end
