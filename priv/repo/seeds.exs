# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Updtr.Repo.insert!(%Updtr.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
%Updtr.Accounts.User{}
|> Updtr.Accounts.User.changeset(%{
  email: "1@1.com",
  password: "testingthisout"
})
|> Updtr.Repo.insert!()
