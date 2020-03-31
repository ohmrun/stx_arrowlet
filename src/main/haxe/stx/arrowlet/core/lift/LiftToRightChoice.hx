package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.right_choice.term.Base;

class LiftToRightChoice{
  static public function toRightChoice<Ii,Iii,O>(arw:Arrowlet<Ii,O>):Arrowlet<Either<Iii,Ii>,Either<Iii,O>>{
    return Arrowlet.unto(new Base(arw));
  }
}