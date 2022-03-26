defmodule Forum.Threads do
  @moduledoc """
  The Threads context.
  """

  import Ecto.Query, warn: false
  alias Forum.Repo

  alias Forum.Threads.Thread

  @page_size 10

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads()
      [%Thread{}, ...]

  """
  def list_threads do
    Thread
    |> Repo.all()
    |> Repo.preload(:posts)
  end

  @doc """
  Return all the threads paginated with the related posts preloaded.
  """
  @spec list_threads(integer(), integer()) :: list(Thread.t())
  def list_threads(offset, limit) do
    from(
      t in Thread,
      offset: ^offset * @page_size,
      limit: ^limit
    )
    |> Repo.all()
    |> Repo.preload(:posts)
  end

  @doc """
  Return total amount of threads
  """
  @spec get_total_threads() :: integer()
  def get_total_threads() do
    from(
      t in Thread,
      select: count(t.id)
    )
    |> Repo.one!()
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id), do: Repo.get!(Thread, id)

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{data: %Thread{}}

  """
  def change_thread(%Thread{} = thread, attrs \\ %{}) do
    Thread.changeset(thread, attrs)
  end

  alias Forum.Threads.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  @doc """
  List all the most popular thread order by their posts count. The post count is cache whenever
  the post related to thread is being modified
  """
  @spec list_popular_threads() :: list(Thread.t())
  def list_popular_threads do
    from(
      t in Thread,
      order_by: [desc: :post_counter],
      limit: @page_size
    )
    |> Repo.all
  end

  @doc """
  List posts for pagination with offset and limit
  """
  @spec list_posts(offset :: integer(), limit :: integer()) :: list(Post.t())
  def list_posts(offset, limit) do
    from(
      p in Post,
      offset: ^offset * @page_size,
      limit: ^limit
    )
    |> Repo.all()
  end

  @doc """
  Return total amount of posts
  """
  @spec get_posts_count() :: integer()
  def get_posts_count() do
    from(
      p in Post,
      select: count(p.id)
    )
    |> Repo.one!()
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    maybe_increment_post_counter(attrs)
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def maybe_increment_post_counter(attrs) do
    if Map.has_key?(attrs, :thread_id) do
      current_thread = get_thread!(attrs.thread_id)

      current_thread
      |> Thread.changeset(%{ post_counter: current_thread.post_counter + 1 })
      |> Repo.update()
    end
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    maybe_increment_post_counter(attrs)
    maybe_decrement_post_counter(post)

    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def maybe_decrement_post_counter(post) do
    if Map.has_key?(post, :thread_id) do
      current_thread = get_thread!(post.thread_id)

      current_thread
      |> Thread.changeset(%{ post_counter: current_thread.post_counter - 1 })
      |> Repo.update()
    end
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    maybe_decrement_post_counter(post)
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
