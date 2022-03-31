defmodule Forum.ThreadsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Forum.Threads` context.
  """

  @doc """
  Generate a thread.
  """
  def thread_fixture(attrs \\ %{}) do
    {:ok, thread} =
      attrs
      |> Enum.into(%{
        title: "some title",
      })
      |> Forum.Threads.create_thread()

    thread
  end

  def threads_fixture_with_random_counter(counter) do
    Enum.to_list(1..counter)
    |> Enum.map(fn _ -> thread_fixture(%{ post_counter: Enum.random(0..100) }) end)
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    thread = thread_fixture()
    {:ok, post} =
      attrs
      |> Enum.into(%{
        "content" => "some content",
        "thread_id" => "#{thread.id}"
      })
      |> Forum.Threads.create_post()

    post
  end
end
