# Forum

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

Testable online at forum.fly.dev. Check these paths:
- https://forum.fly.dev/threads
- https://forum.fly.dev/posts
- https://forum.fly.dev/threads/popular

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## Points to consider
  1. User can create a Thread on this page.
  2. A Thread has a title of max 140 characters.
  3. User can create a Post on this page which belongs to an existing Thread.
  4. A Post has content of max 10k characters.
  5. As you land on this page, it should display the Top 10 most popular Threads. (Ordering
  is based on the number of Posts a Thread gets)
  6. Not necessary to implement authentication or any user management. Every Thread / Post is anonymous.
Choice of the technology stack is up to you. We use Elixir/Phoenix and React, which you can use, but it is not a must. Bonus points if this is deployed online on any cloud. Note that the frontend UI can be a simple page. The focus should be on the backend architecture.
Put extra thought into the Top 10 requirements. Note down how can you shape the architecture in a way that this solution scales with
● 1K, 1M, 1T Threads
● 1K, 1M, 1T Posts
We will look for how the code is organized, best practices, data structures, and basic documentation about running the code (README.md), implementation details, and design choices. We would also like to see git commits and history as you think through the problem.

## Pages
- [x] Thread creation
- [x] Thread view
- [x] Thread view pagination
- [x] Post creation
- [x] Post view
- [x] Post view pagination
- [x] Posts of thread view
- [x] Top 10 Popular thread

The main difficulty in these requirements is scaling with 10 popular threads and how to display it properly especially when there are cases with high traffic ( the posts and thread are constantly being updated and queried ) and how to scaling it properly as there are spike of high traffic.

My initial on scaling this are:
- Paginate every page which have multiple items.
- On the popular threads view, cache as much as possible. Things like: posts count ( related to a thread )
- Keeping the response time under 200ms or ideally 100ms.
- Probably using k8s or libcluster to scale this.
- The bottleneck might be on the database.
- A common problem on social network website might be n+1 query problem. Kinda being easily solved in Ecto using Repo.preload.

Solution to a few problem when serving page at scale:
- Listing multiple items: pagination
- Listing multiple items with relation that cause n+1 query: Repo.preload
- Running aggregation query like count on popular posts: Using a normalized field like post_counter to allow quick ordering.
- Even faster page load: cache relevant queries when there are query with the same params.
- Auto scaling: with this setup, the database is probably need to be a cluster with multiple read-only instances since the read queries is probably way more than create / update query.
