defmodule Updtr.Mailer do
  use Bamboo.Mailer, otp_app: :updtr
  import Bamboo.Email

  @url Application.get_env(:updtr, Updtr.Mailer)[:base_url]

  def registration_mail(to, token) do
    new_email(
      to: to,
      from: "no-reply@updtr.io",
      subject: "Welcome to Updtr, validate your email",
      text_body:
        "Thanks for joining Updtr click the following link to activate your account: #{@url}/activate/#{
          token
        }"
    )
    |> deliver_later()
  end

  def reset_password(to, token) do
    new_email(
      to: to,
      from: "no-reply@updtr.io",
      subject: "Reset password"
    )
    |> text_body("Dear #{to}

    You've requested a password reset, if you haven't please ignore this email.

    Click the following link to reset your password: #{@url}/reset-password?token=#{token}

    Kind Regards,

    Updtr Team")
    |> deliver_later()
  end
end
