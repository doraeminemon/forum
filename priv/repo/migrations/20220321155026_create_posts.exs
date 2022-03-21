defmodule Forum.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :content, :text
      add :thread_is, references(:threads, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:thread_is])
  end
end
