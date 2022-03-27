defmodule Forum.Threads.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string

    belongs_to :thread, Forum.Threads.Thread

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :thread_id])
    |> validate_required([:content, :thread_id])
    |> validate_length(:content, max: 10000, min: 1)
    |> foreign_key_constraint(:thread_id)
  end
end
