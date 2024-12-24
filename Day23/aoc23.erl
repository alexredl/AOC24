% erl
% > c(aoc23), aoc23:aoc23().
% > q().

-module(aoc23).
-export([aoc23/0]).

aoc23() ->
    % Day 23 of AOC 2024
    io:format("Day 23 of AOC 2024~n"),
    % Part 1
    io:format("Part 1 & 2~n"),

    case file:open("input.txt", [read]) of
        {ok, File} ->
            Connections = read_lines(File, []),
            file:close(File),
            %io:format("Connections: ~p~n", [Connections]),
            AdjacencyList = build_adjacency_list(Connections),
            %io:format("AdjacencyList: ~p~n", [AdjacencyList]),
            Triangles = find_all_triangles(AdjacencyList),
            %io:format("Triangles: ~p~n", [Triangles]),
            UniqueTriangles = remove_duplicate_triangles(Triangles),
            %io:format("UniqueTrianges: ~p~n", [UniqueTriangles]),
            CountT = count_triangles_with_t_computer(UniqueTriangles),
            io:format("Part 1: Number of triangles with at least one computer starting with 't': ~p~n", [CountT]),
            LargestClique = find_largest_clique(adjacency_map_to_list(AdjacencyList)),
            io:format("Part 2: LargestClique: ~p~n", [LargestClique]);
        {error, Reason} ->
            io:format("Failed to open file: ~p ~n", [Reason])
    end.

% read lines and accumulate connections in pairs
read_lines(File, Acc) ->
    case io:get_line(File, "") of
        eof ->
            Acc;
        Line ->
            case string:split(Line, "-") of
                [PC1, PC2] ->
                    read_lines(File, [{PC1, string:trim(PC2)} | Acc]);
                _ ->
                    read_lines(File, Acc)
            end
    end.

% build adjacency list from connections
build_adjacency_list(Connections) ->
    build_adjacency_list(Connections, #{}).

build_adjacency_list([], Acc) ->
    Acc;

build_adjacency_list([{PC1, PC2} | Rest], Acc) ->
    NewAcc = add_connection(Acc, PC1, PC2),
    build_adjacency_list(Rest, NewAcc).

add_connection(Acc, PC1, PC2) ->
    Acc1 = maps:update_with(PC1, fun(L) -> [PC2 | L] end, [PC2], Acc),
    maps:update_with(PC2, fun(L) -> [PC1 | L] end, [PC1], Acc1).

% find all sets of 3 connected computers (triangles)
find_all_triangles(AdjacencyList) ->
    find_all_triangles(maps:keys(AdjacencyList), AdjacencyList, []).

find_all_triangles([], _, Acc) ->
    Acc;

find_all_triangles([PC | Rest], AdjacencyList, Acc) ->
    case find_triangles_for_pc(PC, AdjacencyList) of
        [] -> find_all_triangles(Rest, AdjacencyList, Acc);
        Triangles -> find_all_triangles(Rest, AdjacencyList, Triangles ++ Acc)
    end.

% check if triangle exists for each computer
find_triangles_for_pc(PC, AdjacencyList) ->
    case maps:get(PC, AdjacencyList, []) of
        [] -> [];
        ConnectedPCs -> find_triangles_with_neighbors(PC, ConnectedPCs, AdjacencyList)
    end.

% check triangles for neighbors of PC
find_triangles_with_neighbors(_, [], _AdjacencyList) -> [];

find_triangles_with_neighbors(PC, [PC1 | Rest], AdjacencyList) ->
    case maps:get(PC1, AdjacencyList, []) of
        [] -> find_triangles_with_neighbors(PC, Rest, AdjacencyList);
        ConnectedPCs ->
            find_valid_triangles(PC, PC1, ConnectedPCs, AdjacencyList) ++
            find_triangles_with_neighbors(PC, Rest, AdjacencyList)
    end.

% check for valid triangles
find_valid_triangles(PC, PC1, ConnectedPCs, AdjacencyList) ->
    lists:flatmap(fun(PC2) ->
        ConnectionValid = is_connected(PC, PC2, AdjacencyList),
        if
            PC2 =/= PC andalso PC2 =/= PC1 andalso ConnectionValid ->
                [[PC, PC1, PC2]];
            true -> []
        end
    end, ConnectedPCs).

% check if two computers are connected in adjacency list
is_connected(PC1, PC2, AdjacencyList) ->
    lists:member(PC2, maps:get(PC1, AdjacencyList, [])).

% remove duplicate triangles
remove_duplicate_triangles(Triangles) ->
    TrianglesSorted = lists:map(fun(Triangle) -> lists:usort(Triangle) end, Triangles),
    UniqueTriangles = lists:usort(TrianglesSorted),
    UniqueTriangles.

% count how many triangles contain at least one 't' at the start
count_triangles_with_t_computer(Triangles) ->
    lists:foldl(
        fun(Triangle, Acc) ->
            case contains_t_computer(Triangle) of
                true -> Acc + 1;
                false -> Acc
            end
        end, 0, Triangles).

% check if any computer starts with 't' in a triangle
contains_t_computer(Triangle) ->
    lists:foldl(
        fun(PC, Acc) ->
            case hd(PC) of
                116 -> true;
                _ -> Acc
            end
        end, false, Triangle).

% convert AdjacencyList (which is a Map) into a real AdjacencyListList (which is a list)
adjacency_map_to_list(AdjacencyList) ->
    maps:fold(
        fun(Key, Value, Acc) ->
            [{list_to_atom(Key), lists:map(fun list_to_atom/1, Value)} | Acc]
        end, [], AdjacencyList).

% find largest clique
find_largest_clique(Graph) ->
    Cliques = find_maximal_cliques(Graph),
    %io:format("Cliques: ~p~n", [Cliques]),
    lists:foldl(
        fun(Clq, Acc) ->
            case length(Clq) > length(Acc) of
                true -> Clq;
                false -> Acc
            end
        end, [], Cliques).

% find all max cliques
find_maximal_cliques(Graph) ->
    Nodes = [Node || {Node, _} <- Graph],
    AdjMap = maps:from_list(Graph),
    bron_kerbosch([], Nodes, [], AdjMap, []).

% do Bron-Kerbosch algorithm
bron_kerbosch(R, P, X, Graph, Cliques) ->
    %io:format("BK:~n R=~p~n P=~p~n X=~p~n Cliques=~p~n ", [R, P, X, Cliques]),
    case {P, X} of
        {[], []} ->
            [R | Cliques];
        _ ->
            lists:foldl(
                fun(V, Acc) ->
                    Neighbors = maps:get(V, Graph, []),
                    bron_kerbosch(
                        lists:append(R, [V]),
                        lists:filter(fun(N) -> lists:member(N, Neighbors) end, P),
                        lists:filter(fun(N) -> lists:member(N, Neighbors) end, X),
                        Graph,
                        Acc
                    )
                end, Cliques, P)
    end.

