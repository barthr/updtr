defmodule Updtr.Repo.Migrations.AddFullTextSearch do
  use Ecto.Migration

  def change do
    alter table(:bookmarks) do
      add :bookmark_text_ts, :tsvector
    end

    execute "CREATE TRIGGER bookmark_text_ts BEFORE INSERT OR UPDATE ON bookmarks
      FOR EACH ROW EXECUTE PROCEDURE
        tsvector_update_trigger(bookmark_text_ts, 'pg_catalog.english', title, content)
      "

    create index("bookmarks", ["bookmark_text_ts"], using: :gin)
  end
end
