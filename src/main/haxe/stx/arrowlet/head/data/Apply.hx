package stx.arrowlet.head.data;

import stx.arrowlet.pack.Arrowlet in ArrowletA;

typedef Apply<I,O> = ArrowletA<Tuple2<ArrowletA<I,O>,I>,O>;