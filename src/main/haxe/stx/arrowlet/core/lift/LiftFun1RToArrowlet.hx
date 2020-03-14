package stx.arrowlet.core.lift;

class LiftFun1RToArrowlet{
  inline static public function toArrowlet<A,B,C>(fn:A->B):Arrowlet<A,B>{
    return Arrowlet.fromFun1R(fn);
  }
}