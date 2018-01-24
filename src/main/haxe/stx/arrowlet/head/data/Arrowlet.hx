package stx.arrowlet.head.data;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)
typedef Arrowlet<I,O> = I -> Sink<O> -> Block;
