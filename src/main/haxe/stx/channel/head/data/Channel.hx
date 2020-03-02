package stx.channel.head.data;

import stx.arrowlet.core.pack.Arrowlet in ArrowletA;

typedef Channel<I,O,E> = ArrowletA<Outcome<I,E>,Outcome<O,E>>;