defmodule UpdtrWeb.ResetPasswordController do
  use UpdtrWeb, :controller

  alias Updtr.Accounts
  alias UpdtrWeb.Auth

  def new(conn, _) do
    conn
    |> render("new.html")
  end
end
