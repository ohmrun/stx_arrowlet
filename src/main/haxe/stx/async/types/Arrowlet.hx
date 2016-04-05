package stx.async.types;

import hx.Maybe;
import stx.data.*;
import tink.core.Callback;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)
typedef Arrowlet<I,O> = I -> Sink<O> -> Maybe<Block>;
