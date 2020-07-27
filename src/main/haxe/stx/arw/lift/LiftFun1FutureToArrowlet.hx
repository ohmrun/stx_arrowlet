package stx.arw.lift;

import stx.arw.arrowlet.term.Fun1Future;

class LiftFun1FutureToArrowlet{
  static public function toArrowlet<I,O>(fn:I->Future<O>):Arrowlet<I,O,Dynamic>{
    return Arrowlet.lift(new Fun1Future(fn).asArrowletDef());
  }
}