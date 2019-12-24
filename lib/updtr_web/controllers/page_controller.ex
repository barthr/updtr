defmodule UpdtrWeb.PageController do
  use UpdtrWeb, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:info, "Welcome!")
    |> render("index.html")
  end
end
