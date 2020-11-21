package stx.arw.lift;

class LiftFun2RToArrowlet{
  static public inline function toArrowlet<Ii,Iii,O>(fn:Ii->Iii->O):Arrowlet<Couple<Ii,Iii>,O,Dynamic>{
    return Arrowlet.fromFun2R(fn);
  }
}