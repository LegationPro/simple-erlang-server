-module(my_app_app).

-export([
    start/0, stop/0,
    add_count/0, get_count/0]).

-export([init/0]).

-record(state, {count}).

start() ->
    spawn(?MODULE, init, []).

stop() ->
    ?MODULE ! stop,
    ok.

add_count() ->
    ?MODULE ! add_count,
    ok.

get_count() ->
    ?MODULE ! {self(), get_count},
    receive { count, Count } -> Count end.

init() ->
    register(?MODULE, self()),
    loop(#state{count=0}).


loop(#state{count=Count}) ->
    receive Msg ->
        case Msg of
            stop ->
                exit(normal);
            add_count ->
                io:format("add to count!~n");
            {From, get_count} ->
                From ! {count, Count}
            end
        end,
        loop(#state{count=Count+1}).

