package stx.arw.lift;

import stx.arw.left_choice.term.Base;

class LiftToLeftChoice{
  static public function toLeftChoice<I,Oi,Oii,E>(arw:Arrowlet<I,Oi,E>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>,E>{
    return Arrowlet.lift(new Base(arw));
  }
}