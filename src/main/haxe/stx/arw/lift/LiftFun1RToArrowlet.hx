package stx.arw.lift;

class LiftFun1RToArrowlet{
  static public inline function toArrowlet<P,R>(fn:P->R):Arrowlet<P,R,Dynamic>{
    return Arrowlet.fromFun1R(fn);
  }
}