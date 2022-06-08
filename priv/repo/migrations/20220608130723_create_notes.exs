defmodule Notifyapp.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :text

      timestamps()
    end
  end
end
