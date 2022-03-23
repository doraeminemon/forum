defmodule Forum.ThreadsTest do
  use Forum.DataCase

  alias Forum.Threads

  describe "threads" do
    alias Forum.Threads.Thread

    import Forum.ThreadsFixtures

    @invalid_attrs %{title: nil}

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert Threads.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Threads.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Thread{} = thread} = Threads.create_thread(valid_attrs)
      assert thread.title == "some title"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Threads.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Thread{} = thread} = Threads.update_thread(thread, update_attrs)
      assert thread.title == "some updated title"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Threads.update_thread(thread, @invalid_attrs)
      assert thread == Threads.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Threads.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Threads.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Threads.change_thread(thread)
    end
  end

  describe "posts" do
    alias Forum.Threads.Post

    import Forum.ThreadsFixtures

    @invalid_attrs %{content: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Threads.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Threads.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      thread = thread_fixture()
      valid_attrs = %{content: "some content", thread_id: thread.id}

      assert {:ok, %Post{} = post} = Threads.create_post(valid_attrs)
      assert post.content == "some content"
    end

    test "create_post/1 with a thread id increment the post counter" do
      thread = thread_fixture()
      valid_attrs = %{content: "some content", thread_id: thread.id}

      assert {:ok, %Post{} = post} = Threads.create_post(valid_attrs)
      thread = Threads.get_thread!(thread.id)
      assert thread.post_counter == 1
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Threads.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Post{} = post} = Threads.update_post(post, update_attrs)
      assert post.content == "some updated content"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Threads.update_post(post, @invalid_attrs)
      assert post == Threads.get_post!(post.id)
    end

    test "update_post/2 increment the new thread while decrement the old thread post counter" do
      post = post_fixture()
      thread_id = post.thread_id
      new_thread = thread_fixture()

      update_attrs = %{thread_id: new_thread.id}

      assert {:ok, %Post{} = post} = Threads.update_post(post, update_attrs)
      thread = Threads.get_thread!(thread_id)
      assert thread.post_counter == 0
      new_thread = Threads.get_thread!(new_thread.id)
      assert new_thread.post_counter == 1
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Threads.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Threads.get_post!(post.id) end
    end

    test "delete_post/1 decrement the post counter" do
      post = post_fixture()
      thread_id = post.thread_id

      thread = Threads.get_thread!(thread_id)
      assert thread.post_counter == 1

      assert {:ok, %Post{}} = Threads.delete_post(post)
      thread = Threads.get_thread!(thread_id)
      assert thread.post_counter == 0
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Threads.change_post(post)
    end

    test "get_popular_thread will get the 10 most popular thread" do
      threads_fixture_with_random_counter(20)

      popular_threads = Threads.list_popular_threads()

      assert Enum.count(popular_threads) == 10
      assert popular_threads
        |> hd
        |> Map.fetch(:post_counter) >
        popular_threads
        |> List.last()
        |> Map.fetch(:post_counter)
    end
  end
end
