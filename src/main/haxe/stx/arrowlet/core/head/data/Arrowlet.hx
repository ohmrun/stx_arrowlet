package stx.arrowlet.core.head.data;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)

typedef Arrowlet<I,O> = stx.arrowlet.core.head.Data.Wildcard -> Sink<O> -> I -> Block;
