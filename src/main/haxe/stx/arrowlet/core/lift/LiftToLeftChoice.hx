package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.left_choice.term.Base;

class LiftToLeftChoice{
  static public function toLeftChoice<I,Oi,Oii>(arw:Arrowlet<I,Oi>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>>{
    return Arrowlet.unto(new Base(arw));
  }
}