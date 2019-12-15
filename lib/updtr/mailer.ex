defmodule Updtr.Mailer do
  use Bamboo.Mailer, otp_app: :updtr
  import Bamboo.Email

  def registration_mail(to, link) do
    new_email(
      to: to,
      from: "no-reply@updtr.io",
      subject: "Welcome to Updtr, validate your email",
      text_body:
        "Thanks for joining Updtr click the following link to activate your account: #{link}"
    )
  end

  def reset_password(to, link) do
    new_email(
      to: to,
      from: "no-reply@updtr.io",
      subject: "Reset password",
      text_body: "Click the following link to reset your password: #{link}"
    )
  end
end
