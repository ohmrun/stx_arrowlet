package stx.arrowlet.core.head.data;

import stx.arrowlet.core.pack.Arrowlet in ArrowletA;

typedef Apply<I,O> = Arrowlet<Tuple2<Arrowlet<I,O>,I>,O>;