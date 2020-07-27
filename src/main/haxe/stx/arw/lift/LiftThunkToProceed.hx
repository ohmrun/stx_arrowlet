package stx.arw.lift;

class LiftThunkToProceed{
  static public function cascade<O,E>(ipt:Void->O):Proceed<O,E>{
    return Proceed.fromFunXR(ipt);
  }
}