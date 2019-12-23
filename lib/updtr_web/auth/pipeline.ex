defmodule UpdtrWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :updtr,
    error_handler: UpdtrWeb.Auth.ErrorHandler,
    module: UpdtrWeb.Auth.Guardian

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.LoadResource
end
