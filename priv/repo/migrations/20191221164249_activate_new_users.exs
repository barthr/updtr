defmodule Updtr.Repo.Migrations.ActivateNewUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :is_active
      add :activation_token, :string
    end

    create unique_index(:users, [:activation_token])
  end
end
