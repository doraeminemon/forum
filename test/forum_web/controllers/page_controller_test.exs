defmodule ForumWeb.PageControllerTest do
  use ForumWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Most popular threads"
  end
end
