defmodule UpdtrWeb.ValidateEmailPlug do
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)

    if user.email_validated do
      conn
    else
      conn
      |> halt()
      |> UpdtrWeb.FallbackController.call({:error, "Please validate your email address"})
    end
  end
end
