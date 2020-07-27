package stx.arw.lift;

import stx.arw.arrowlet.term.ReplyFuture;

class LiftReplyFutureToArrowlet{
  static public function toArrowlet<O>(fn:Void->Future<O>):Arrowlet<Noise,O,Dynamic>{
    return Arrowlet.lift(new ReplyFuture(fn).asArrowletDef());
  }
}