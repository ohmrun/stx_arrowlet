package stx.arrowlet.core.pack;

class Api{
  public function new(){}
  public inline function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>{
      return LiftFunctionToArrowlet.toArrowlet(fn);
  }
}