defmodule UpdtrWeb.PageController do
  use UpdtrWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.mark_path(conn, :index))
  end
end
