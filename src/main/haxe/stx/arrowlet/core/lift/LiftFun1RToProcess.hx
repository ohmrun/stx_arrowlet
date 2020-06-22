package stx.arrowlet.core.lift;

class LiftFun1RToProcess{
  static public function toProcess<P,R>(fn:P->R):Process<P,R>{
    return Process.fromFun1R(fn);
  }
}