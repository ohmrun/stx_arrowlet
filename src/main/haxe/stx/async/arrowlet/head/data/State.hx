package stx.async.arrowlet.head.data;

import stx.async.arrowlet.body.Arrowlet;

typedef State<S,A> = Arrowlet<S,Tuple2<A,S>>;
