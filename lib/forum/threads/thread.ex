defmodule Forum.Threads.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  schema "threads" do
    field :title, :string
    field :post_counter, :integer, default: 0

    has_many :posts, Forum.Threads.Post, on_delete: :delete_all
    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:title, :post_counter])
    |> validate_required([:title])
    |> validate_length(:title, max: 140, min: 1)
  end
end
