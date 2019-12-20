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
    |> deliver_now()
  end

  def reset_password(to, token) do
    new_email(
      to: to,
      from: "no-reply@updtr.io",
      subject: "Reset password"
    )
    |> html_body("<h3>Dear #{to}</h3>
      <p>You've requested a password reset, if you haven't please ignore this email.<br><br>
      Click the following link to reset your password: <a>#{@url}/reset-password?token=#{token}</a><br><br>
      Kind Regards, <br><br>Updtr Team</p>
      ")
    |> deliver_now()
  end
end
