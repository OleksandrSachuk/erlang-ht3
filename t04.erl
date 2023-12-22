-module(t04).
-import(utils, [reverse/1]).
-export([decode/1]).

clean(B) ->
  Len = byte_size(B) - 2,
  <<"'", Rest:Len/binary, "'">> = B,
  Rest.

get_record(B) ->
  get_record(B, <<>>, <<>>).

get_record(<<":", Rest/binary>>, Key, _Value) ->
  get_record(<<>>, Key, Rest);

get_record(<<X/utf8, Rest/binary>>, Key, Value) ->
  get_record(Rest, <<Key/binary, X/utf8>>, Value);

get_record(<<>>, Key, Value) ->
  {clean(Key), clean(Value)}.

decode(B) ->
  decode(B, <<>>, #{}).

decode(<<",", Rest/binary>>, AccRecord, Map) ->
  {Key, Value} = get_record(AccRecord),
  NewMap = maps:put(Key, Value, Map),
  decode(Rest, <<>>, NewMap);

decode(<<"{", Rest/binary>>, AccRecord, Map) ->
  decode(Rest, AccRecord, Map);

decode(<<"}">>, AccRecord, Map) ->
  {Key, Value} = get_record(AccRecord),
  maps:put(Key, Value, Map);

decode(<<X/utf8, Rest/binary>>, AccRecord, Map) ->
  decode(Rest, <<AccRecord/binary, X/utf8>>, Map).