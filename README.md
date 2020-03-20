

## Set up steps

We're assuming you have the `gleam` compiler available in your environment to execute. Run this to
check.
```
gleam --version
```

Run the following commands to set up an empty phoenix project:
```
mkdir gleam-phoenix-mix
cd gleam-phoenix-mix
mix phx.new . --app my_app
mix ecto.create
cd assets 
npm install
cd ..
```

Create a new directory for our gleam compiler task:
```
mkdir -p lib/mix/tasks/compile/
```

Add the follow code in a file called `lib/mix/tasks/compile/gleam.ex`.
```
defmodule Mix.Tasks.Compile.Gleam do
  use Mix.Task.Compiler

  def run(_args) do
    System.cmd("gleam", ["build"])
    :ok
  end
end
```

Run the elixir compiler so that we compile that mix task before we try to use it.
```
mix compile.elixir
```

Create a file called `gleam.toml` in the root of the project with the follow content.
```
name = "my_app"
```

Create a `src` directory for the gleam files.
```
mkdir src
```

Create a file called `src/hello_world.gleam` with the file code in it:
```
pub fn hello() {
  "Hello, from gleam!"
}
```

Make the following change to your `mix.exs` file to add our compiler task to the list of compilers
being run when you do `mix compile` and to make sure mix's erlang compiler looks in the `gen` folder
for erlang files. The `gleam` compiler compiles `.gleam` files from the `src` folder into `.erl`
files in the `gen` folder so we need the erlang compiler to find them there.
```diff
       elixir: "~> 1.5",
       elixirc_paths: elixirc_paths(Mix.env()),
+      erlc_paths: ["src", "gen"],
-      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
+      compilers: [:phoenix, :gettext, :gleam] ++ Mix.compilers(),
       start_permanent: Mix.env() == :prod,
       aliases: aliases(),
```

As a simple demonstration of interop between elixir & compile gleam files, make the following change
to `lib/my_app_web/controllers/page_controller.ex`:
```diff
 defmodule MyAppWeb.PageController do
   use MyAppWeb, :controller
 
   def index(conn, _params) do
-    render(conn, "index.html")
+    render(conn, "index.html", title: :hello_world.hello())
   end
 end
```

And then make the following to `lib/my_app_web/templates/page/index.html.eex`:
```diff
 <section class="phx-hero">
-  <h1><%= gettext "Welcome to %{name}!", name: "Phoenix" %></h1>
+  <h1><%= @title %></h1>
   <p>A productive web framework that<br/>does not compromise speed or maintainability.</p>
 </section>
```

Then run:
```
mix compile
mix phx.server
```

And load `http://localhost:4000` in your browser to you should see "Hello, from gleam!" in the
centre of the standard Phoenix welcome page.
