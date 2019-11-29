package stx.arrowlet.core.head.data;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)

/**
 *  The wildcard is used to get the default abstract hoisting out of the way so that:
 *      (A -> B -> C) -> Arrowlet<Tuple2<A,B>,C>
 *  works.
 */
typedef Arrowlet<I,O> = Wildcard -> Sink<O> -> I -> Block;
