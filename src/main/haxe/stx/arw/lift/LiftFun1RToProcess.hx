package stx.arw.lift;

class LiftFun1RToConvert{
  static public function toConvert<P,R>(fn:P->R):Convert<P,R>{
    return Convert.fromFun1R(fn);
  }
}