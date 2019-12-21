defmodule UpdtrWeb.UserView do
  use UpdtrWeb, :view
  alias UpdtrWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, email: user.email, is_active: user.is_active}
  end

  def render("sign_up.json", %{message: message}) do
    %{data: %{message: message}}
  end

  def render("sign_in.json", %{token: token, user: user}) do
    %{
      data: %{
        token: token,
        user: render("user.json", user: user)
      }
    }
  end
end
