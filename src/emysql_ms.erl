%% @author bai
%% @doc @todo Add description to emysql_ms.


-module(emysql_ms).

%% ====================================================================
%% API functions
%% ====================================================================
-export([
	start/0,
	
	get_client/2,	
		
	select/4,
	update/4,
	delete/4,
	insert/4
]).
-define(RETRIES,3).
-define(TIMEOUT,30*1000).

get_client(Poolname,Key)->
	ems:get_client_write(Poolname,Key).

select(Poolname,Key,Query, Params) ->
	case ems:get_client_read(Poolname,Key) of
		{ok,Client}->
			query(Client, Query, Params);
		R->
			R
	end.
update(Poolname,Key,Query, Params) ->
	insert(Poolname,Key,Query, Params).
delete(Poolname,Key,Query, Params) ->
	insert(Poolname,Key,Query, Params).
insert(Poolname,Key,Query, Params) ->
	case ems:get_client_write(Poolname,Key) of
		{ok,Client}->
			query(Client, Query, Params);
		R->
			R
	end.

query(Client, Query, Params)->
	mysql:query(Client, Query, Params,?TIMEOUT).



%% ====================================================================
%% Internal functions
%% ====================================================================
%% 启动方法
start()->
	%% 含连接从节点过程。
	ok = start(?MODULE),
	ok.
%% 启动App
start(App) ->
    start_ok(App, application:start(App, permanent)).
start_ok(_App, ok) -> ok;
start_ok(_App, {error, {already_started, _App}}) -> ok;
start_ok(App, {error, {not_started, Dep}}) ->
    ok = start(Dep),
    start(App);
start_ok(App, {error, Reason}) ->
    erlang:error({aps_start_failed, App, Reason}).



