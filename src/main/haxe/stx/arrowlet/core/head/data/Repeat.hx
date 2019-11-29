package stx.arrowlet.core.head.data;

import stx.arrowlet.core.pack.Arrowlet in ArrowletA;

typedef Repeat<I,O> = ArrowletA<I,Either<I,O>>;
