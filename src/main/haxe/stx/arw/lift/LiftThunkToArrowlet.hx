package stx.arw.lift;

class LiftThunkToArrowlet{
  static public inline function toArrowlet<O>(fn:Void->O):Arrowlet<Noise,O,Dynamic>{
    return Arrowlet.fromFunXR(fn);
  }
}