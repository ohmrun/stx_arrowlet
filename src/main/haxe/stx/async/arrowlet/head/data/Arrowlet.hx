package stx.async.arrowlet.head.data;

import stx.Maybe;
import stx.data.*;
import tink.core.Callback;

//(A -> R) -> R
//(I -> (O -> Void)) -> Void
//((R, A) => R)
typedef Arrowlet<I,O> = I -> Sink<O> -> CallbackLink;
