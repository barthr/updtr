defmodule Updtr.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id)
      add :title, :text
      add :url, :text
      add :hashed_url, :text
      add :content, :text

      timestamps()
    end

  end
end
