package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.left_choice.term.Choice   in LeftChoicicle;
import stx.arrowlet.core.pack.right_choice.term.Choice  in RightChoicicle;

class LiftChoiceToArrowlet{
  static public function left<I,O,E>(self:Arrowlet<I,Either<O,I>,E>):Arrowlet<Either<I,I>,Either<O,I>,E>{
    return Arrowlet.lift(new LeftChoicicle(self).asArrowletDef());
  }
  static public function right<I,O,E>(self:Arrowlet<I,Either<O,I>,E>):Arrowlet<Either<I,I>,Either<I,O>,E>{
    return Arrowlet.lift(new RightChoicicle(self).asArrowletDef());
  }
}