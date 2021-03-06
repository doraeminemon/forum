defmodule ForumWeb.ThreadLive.FormComponent do
  use ForumWeb, :live_component

  alias Forum.Threads

  @impl true
  def update(%{thread: thread} = assigns, socket) do
    changeset = Threads.change_thread(thread)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"thread" => thread_params}, socket) do
    changeset =
      socket.assigns.thread
      |> Threads.change_thread(thread_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"thread" => thread_params}, socket) do
    save_thread(socket, socket.assigns.action, thread_params)
  end

  defp save_thread(socket, :edit, thread_params) do
    case Threads.update_thread(socket.assigns.thread, thread_params) do
      {:ok, _thread} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thread updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_thread(socket, :new, thread_params) do
    case Threads.create_thread(thread_params) do
      {:ok, _thread} ->
        {:noreply,
         socket
         |> put_flash(:info, "Thread created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
