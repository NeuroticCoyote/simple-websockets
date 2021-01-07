%%%-------------------------------------------------------------------
%%% @author joegoodwin
%%% @copyright (C) 2021
%%% @doc
%%%
%%% @end
%%% Created : 07. Jan 2021 11:06
%%%-------------------------------------------------------------------
-module(websockets_server).
-author("joegoodwin").

-behaviour(cowboy_websocket_handler).

-export([
	init/3,
	websocket_init/3,
	websocket_handle/3,
	websocket_info/3,
	websocket_terminate/3
]).

init({tcp, http}, _Req, _Opts) ->
	{upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
	io:format("init websocket~n"),
	{ok, Req, undefined_state}.

websocket_handle({text, Msg}, Req, State) ->
	io:format("Got data: ~p~n", [Msg]),
	{reply, {text, << "RECV: ", Msg/binary , "\r\n">>}, Req, State, hibernate };
websocket_handle(_Any, Req, State) ->
	{reply, {text, <<>>}, Req, State, hibernate}.

websocket_info({timeout, _Ref, Msg}, Req, State) ->
	{reply, {text, Msg}, Req, State};
websocket_info(_Info, Req, State) ->
	{ok, Req, State, hibernate}.

websocket_terminate(_Reason, _Req, _State) ->
	ok.
