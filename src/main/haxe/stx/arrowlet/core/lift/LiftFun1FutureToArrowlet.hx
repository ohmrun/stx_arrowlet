package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.arrowlet.term.Fun1Future;

class LiftFun1FutureToArrowlet{
  static public function toArrowlet<I,O>(fn:I->Future<O>):Arrowlet<I,O>{
    return Arrowlet.lift(new Fun1Future(fn).asRecallDef());
  }
}