defmodule UpdtrWeb.Auth.Guardian do
  use Guardian, otp_app: :updtr

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Updtr.Accounts.get_user!(id)
    {:ok, resource}
  end

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end
end
