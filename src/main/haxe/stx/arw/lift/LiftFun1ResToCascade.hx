package stx.arw.lift;

class LiftFun1ResToCascade{
  static public function toCascade<I,O,E>(fn:I->Res<O,E>):Cascade<I,O,E>{
    return Cascade.fromFun1Res(fn);
  }
}