package stx.arw.lift;

import stx.arw.arrowlet.term.Handler;

//FunYX
class LiftHandlerToArrowlet{
  static public inline function toArrowlet<O>(fn:(O->Void)->Void):Arrowlet<Noise,O,Dynamic>{
    return Arrowlet.lift(new Handler(fn).asArrowletDef());
  }
}