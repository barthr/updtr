defmodule UpdtrWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :updtr,
    error_handler: UpdtrWeb.Auth.ErrorHandler,
    module: UpdtrWeb.Auth.Guardian

  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  # Load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource
end
