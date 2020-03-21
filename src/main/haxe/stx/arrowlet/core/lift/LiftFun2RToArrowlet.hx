package stx.arrowlet.core.lift;

class LiftFun2RToArrowlet{
  inline static public function toArrowlet<Ii,Iii,O>(fn:Ii->Iii->O):Arrowlet<Couple<Ii,Iii>,O>{
    return Arrowlet.fromFun2R(fn);
  }
}