defmodule UpdtrWeb.PasswordResetView do
  use UpdtrWeb, :view

  def render("token_error.json", %{message: message}) do
    %{errors: %{detail: message}}
  end
end
