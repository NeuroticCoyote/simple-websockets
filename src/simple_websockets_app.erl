%%%-------------------------------------------------------------------
%% @doc simple_websockets public API
%% @end
%%%-------------------------------------------------------------------

-module(simple_websockets_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    application:ensure_all_started(cowboy),
    enable_http_endpoints(),
    {ok, self()}. %% we dont need a supervisor

stop(_State) ->
    ok.

%% internal functions
enable_http_endpoints() ->
    Dispatch = cowboy_router:compile(
        [
            {'_', [
                {"/", cowboy_static, {priv_file, simple_websockets, "root.html"}},
                {"/websocket", websockets_server, []}
            ]}
        ]
    ),
    {ok, _} = cowboy:start_http(my_http_listener, 100, [{port, 8080}], [{env, [{dispatch, Dispatch}]}]).