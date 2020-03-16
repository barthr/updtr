defmodule UpdtrWeb.Auth.ErrorHandler do
  import Plug.Conn
  use UpdtrWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler
  @impl Guardian.Plug.ErrorHandler

  def auth_error(conn, {type, _reason}, _opts)
      when type in [:unauthorized, :invalid_token] do
    conn
    |> put_flash(:error, "Login required")
    |> redirect(to: Routes.auth_path(conn, :new))
    |> halt()
  end

  # TODO error handling of different types
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, "Login required")
    |> redirect(to: Routes.auth_path(conn, :new))
    |> halt()
  end
end
