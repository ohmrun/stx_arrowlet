package stx.arrowlet.head.data;

import stx.arrowlet.pack.Arrowlet in ArrowletA;

typedef Repeat<I,O> = ArrowletA<I,Either<I,O>>;
