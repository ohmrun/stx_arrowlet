package stx.arrowlet.head.data;

import stx.arrowlet.pack.Arrowlet in ArrowletA;

typedef State<S,A> = ArrowletA<S,Tuple2<A,S>>;
