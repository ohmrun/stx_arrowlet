package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.arrowlet.term.Handler;

//FunYX
class LiftHandlerToArrowlet{
  static public function toArrowlet<O>(fn:(O->Void)->Void):Arrowlet<Noise,O,Dynamic>{
    return Arrowlet.lift(new Handler(fn).asArrowletDef());
  }
}