package stx.arrowlet.core.head.data;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)

typedef Arrowlet<I,O> = Recall<I,O,Automation>;
