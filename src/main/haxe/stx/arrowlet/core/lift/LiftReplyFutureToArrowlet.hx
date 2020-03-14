package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.arrowlet.term.ReplyFuture;

class LiftReplyFutureToArrowlet{
  static public function toArrowlet<O>(fn:Void->Future<O>):Arrowlet<Noise,O>{
    return Arrowlet.lift(new ReplyFuture(fn).asRecallDef());
  }
}