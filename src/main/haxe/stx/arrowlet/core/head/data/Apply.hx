package stx.arrowlet.core.head.data;

import stx.arrowlet.core.pack.Arrowlet in ArrowletA;

typedef Apply<I,O> = ArrowletA<Tuple2<ArrowletA<I,O>,I>,O>;