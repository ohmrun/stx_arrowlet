package stx.arrowlet.core.lift;

import stx.arrowlet.core.pack.left_choice.term.Choice   in LeftChoicicle;
import stx.arrowlet.core.pack.right_choice.term.Choice  in RightChoicicle;

class LiftChoiceToArrowlet{
  static public function left<I,O>(self:Arrowlet<I,Either<O,I>>):Arrowlet<Either<I,I>,Either<O,I>>{
    return Arrowlet.lift(new LeftChoicicle(self).asRecallDef());
  }
  static public function right<I,O>(self:Arrowlet<I,Either<O,I>>):Arrowlet<Either<I,I>,Either<I,O>>{
    return Arrowlet.lift(new RightChoicicle(self).asRecallDef());
  }
}