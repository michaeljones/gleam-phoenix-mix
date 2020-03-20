-module(hello_world).
-compile(no_auto_import).

-export([hello/0]).

hello() ->
    <<"Hello, from gleam!">>.
