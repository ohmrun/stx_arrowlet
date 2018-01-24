package stx.arrowlet.core.head.data;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)
import stx.arrowlet.Package.Handler in HandlerA;
import stx.arrowlet.Package.Fly in FlyA;

typedef Arrowlet<I,O> = FlyA<I,O> -> Block;
