defmodule Updtr.Repo.Migrations.CreateVerifications do
  use Ecto.Migration

  def change do
    create table(:password_resets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id)
      add :password_reset_token, :string, null: false

      add :valid_until, :naive_datetime,
        default: fragment("now() - interval '1 hour'"),
        null: false

      timestamps()
    end

    alter table(:users) do
      add :email_validated, :boolean, default: false
    end

    create unique_index(:password_resets, [:password_reset_token])
  end
end
