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
        title: "some title"
      })
      |> Forum.Threads.create_thread()

    thread
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Forum.Threads.create_post()

    post
  end
end
