-module(t03).
-import(utils, [reverse/1]).
-export([split/2]).

split(B, Delimiter) ->
  split(B, list_to_binary(Delimiter), <<>>, []).

split(B, Delimiter, AccWord, AccList) ->
  Length = byte_size(Delimiter),
  case B of
    <<Delimiter:Length/binary, Rest/binary>> ->
      split(Rest, Delimiter, <<>>, [AccWord|AccList]);
    <<X/utf8, Rest/binary>> ->
      split(Rest, Delimiter, <<AccWord/binary, X/utf8>>, AccList);
    <<>> ->
      reverse([AccWord|AccList])
  end.