defmodule UpdtrWeb.Auth.ErrorHandler do
  import Plug.Conn
  use UpdtrWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, _reason}, _opts) do
    message = to_string(type)

    conn
    |> put_view(UpdtrWeb.ErrorView)
    |> put_status(401)
    |> render("401.json", message: message)
  end
end
