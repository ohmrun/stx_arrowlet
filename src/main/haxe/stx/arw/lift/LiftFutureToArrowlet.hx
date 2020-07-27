package stx.arw.lift;

import stx.arw.arrowlet.term.Future;

import tink.core.Future in TinkFuture;

class LiftFutureToArrowlet{
  static public function then<T,TT,E>(ft:TinkFuture<T>,arw:Arrowlet<T,TT,E>):Arrowlet<Noise,TT,E>{
    return Arrowlet.lift(new Future(ft).asArrowletDef()).then(arw);
  }
}