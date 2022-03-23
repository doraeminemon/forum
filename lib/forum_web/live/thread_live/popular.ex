defmodule ForumWeb.ThreadLive.Popular do
  use ForumWeb, :live_view

  alias Forum.Threads
  alias Forum.Threads.Thread

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :threads, list_popular_thread())}
  end

  defp list_popular_thread() do
    Threads.list_popular_threads()
  end

end
