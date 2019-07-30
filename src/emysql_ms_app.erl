%%%-------------------------------------------------------------------
%% @doc emysql_ms public API
%% @end
%%%-------------------------------------------------------------------

-module(emysql_ms_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    emysql_ms_sup:start_link().

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================