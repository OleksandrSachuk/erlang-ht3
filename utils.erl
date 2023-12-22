-module(utils).
-export([reverse/1, len/1]).

reverse(L) ->
  reverse(L, []).

reverse([H|T], Acc) ->
  reverse(T, [H|Acc]);
reverse([], Acc) ->
  Acc.

len(B) ->
  len(B, 0).

len(<<_/utf8, Rest/binary>>, I) ->
  len(Rest, I + 1);
len(<<>>, I) ->
  I.