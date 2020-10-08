package stx.arw.lift;

class LiftThunkToProduce{
  static public function cascade<O,E>(ipt:Void->O):Produce<O,E>{
    return Produce.fromFunXR(ipt);
  }
}