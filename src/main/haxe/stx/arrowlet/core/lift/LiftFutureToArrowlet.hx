package stx.arrowlet.core.lift;

import stx.run.pack.recall.term.Base;
import stx.arrowlet.core.pack.arrowlet.term.Future;

import tink.core.Future in TinkFuture;

class LiftFutureToArrowlet{
  static public function then<T,TT>(ft:TinkFuture<T>,arw:Arrowlet<T,TT>):Arrowlet<Noise,TT>{
    return Arrowlet.lift(new Future(ft).asRecallDef()).then(arw);
  }
}