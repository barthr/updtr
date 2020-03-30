defmodule Updtr.Repo.Migrations.AddThumbnail do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :thumbnail, :string
    end
  end
end
