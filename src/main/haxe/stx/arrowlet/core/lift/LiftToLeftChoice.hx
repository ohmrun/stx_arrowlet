package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.left_choice.term.Base;

class LiftToLeftChoice{
  static public function toLeftChoice<I,Oi,Oii,E>(arw:Arrowlet<I,Oi,E>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>,E>{
    return Arrowlet.lift(new Base(arw));
  }
}