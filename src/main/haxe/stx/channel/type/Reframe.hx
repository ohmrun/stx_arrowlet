package stx.channel.type;

import stx.channel.head.data.Channel in ChannelT;

typedef Reframe<S,A,E> = Channel<S,Tuple2<A,S>,E>;