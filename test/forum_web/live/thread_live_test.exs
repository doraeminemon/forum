defmodule ForumWeb.ThreadLiveTest do
  use ForumWeb.ConnCase

  import Phoenix.LiveViewTest
  import Forum.ThreadsFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some updated title"}
  @invalid_attrs %{title: nil}

  defp create_thread(_) do
    thread = thread_fixture()
    %{thread: thread}
  end

  describe "Index" do
    setup [:create_thread]

    test "lists all threads", %{conn: conn, thread: thread} do
      {:ok, _index_live, html} = live(conn, Routes.thread_index_path(conn, :index))

      assert html =~ "Listing Threads"
      assert html =~ thread.title
    end

    test "saves new thread", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.thread_index_path(conn, :index))

      assert index_live |> element("a", "New Thread") |> render_click() =~
               "New Thread"

      assert_patch(index_live, Routes.thread_index_path(conn, :new))

      assert index_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#thread-form", thread: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_index_path(conn, :index))

      assert html =~ "Thread created successfully"
      assert html =~ "some title"
    end

    test "updates thread in listing", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_index_path(conn, :index))

      assert index_live |> element("#thread-#{thread.id} a", "Edit") |> render_click() =~
               "Edit Thread"

      assert_patch(index_live, Routes.thread_index_path(conn, :edit, thread))

      assert index_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#thread-form", thread: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_index_path(conn, :index))

      assert html =~ "Thread updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes thread in listing", %{conn: conn, thread: thread} do
      {:ok, index_live, _html} = live(conn, Routes.thread_index_path(conn, :index))

      assert index_live |> element("#thread-#{thread.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#thread-#{thread.id}")
    end
  end

  describe "Show" do
    setup [:create_thread]

    test "displays thread", %{conn: conn, thread: thread} do
      {:ok, _show_live, html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Show Thread"
      assert html =~ thread.title
    end

    test "updates thread within modal", %{conn: conn, thread: thread} do
      {:ok, show_live, _html} = live(conn, Routes.thread_show_path(conn, :show, thread))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Thread"

      assert_patch(show_live, Routes.thread_show_path(conn, :edit, thread))

      assert show_live
             |> form("#thread-form", thread: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#thread-form", thread: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.thread_show_path(conn, :show, thread))

      assert html =~ "Thread updated successfully"
      assert html =~ "some updated title"
    end
  end
end
