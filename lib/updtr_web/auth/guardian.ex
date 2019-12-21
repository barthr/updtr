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

  def authenticate(email, password) do
    case Updtr.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        create_token(user)

      {:error, _message} ->
        {:error, :unauthorized}
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, token, user}
  end
end
