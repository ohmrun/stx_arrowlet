package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.right_choice.term.Base;

class LiftToRightChoice{
  static public function toRightChoice<Ii,Iii,O,E>(arw:Arrowlet<Ii,O,E>):Arrowlet<Either<Iii,Ii>,Either<Iii,O>,E>{
    return Arrowlet.lift(new Base(arw));
  }
}