defmodule ForumWeb.PostLive.Index do
  use ForumWeb, :live_view

  alias Forum.Threads
  alias Forum.Threads.Post

  @impl true
  def mount(_params, _session, socket) do
    socket = socket
    |> assign(:page, 1)
    |> assign(:total, Threads.get_posts_count())
    |> assign(:posts, list_posts(1))

    {:ok, socket}
  end

  @impl true
  def handle_params(%{ "page" => page }, _url, socket) do
    socket = socket
      |> assign(:page, String.to_integer(page))
      |> assign(:posts, list_posts(String.to_integer(page)))
    {:noreply, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Threads.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Threads.get_post!(id)
    {:ok, _} = Threads.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts(0))}
  end

  defp list_posts(page) do
    Threads.list_posts(page - 1, 10)
  end
end
