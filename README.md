emysql_ms
=====

An OTP application

Build
-----
	不需要Key参数的，读写落在第一个sharding，方便锁死数据库位置。

	create table test(
		id bigint primary key,
		age int
	);

    $ rebar3 compile
    $ erl -pa _build/default/lib/*/ebin -pa _build/default/lib/*/priv -config sys.config -s emysql_ms
    > ems:add_ms([]).
    
    > emysql_ms:select(pool,<<"m123">>,"select * from test where id=?",[1]).
    > emysql_ms:insert(pool,<<"m123">>,"insert into test(id,age) values(?,?)",[1,20]).
    > emysql_ms:update(pool,<<"m123">>,"update test set age=? where id=?",[29,1]).
    > emysql_ms:delete(pool,<<"m123">>,"delete from test where id=?",[1]).
    
    > {ok,Pid} = emysql_ms:get_client(pool,<<"m123">>).
    > mysql:transaction(Pid, fun () ->
	    ok = mysql:query(Pid, "INSERT INTO test(id,age) VALUES (3,99)"),
	    throw(foo),
	    ok = mysql:query(Pid, "INSERT INTO test(id,age) VALUES (5,88)")
	  end).
    > mysql:insert_id(Pid).
