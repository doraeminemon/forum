defmodule Forum.Repo.Migrations.AddPostCount do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      add :post_counter, :integer
    end
  end
end
