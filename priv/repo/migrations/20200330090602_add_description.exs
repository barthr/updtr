defmodule Updtr.Repo.Migrations.AddDescription do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :description, :string
    end
  end
end
