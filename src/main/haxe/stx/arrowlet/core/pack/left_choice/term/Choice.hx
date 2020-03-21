package stx.arrowlet.core.pack.left_choice.term;

import stx.run.pack.recall.term.Base in RecallBase;

class Choice<I,O> extends RecallBase<Either<I,I>,Either<O,I>,Automation>{
  private var delegate : Arrowlet<I,Either<O,I>>;
  public function new(delegate){
    super();
    this.delegate = delegate;
	}
	override public function applyII(either:Either<I,I>,cont:Sink<Either<O,I>>):Automation{
    return switch(either){
      case Left(i)      : Arrowlet.Apply().prepare(__.couple(delegate,i),cont);
      case Right(oii)   : cont(Right(oii)); Automation.unit();
    }
  }
}