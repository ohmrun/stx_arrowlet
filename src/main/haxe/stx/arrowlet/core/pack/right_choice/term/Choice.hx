package stx.arrowlet.core.pack.right_choice.term;

import stx.run.pack.recall.term.Base in RecallBase;

class Choice<I,O> extends RecallBase<Either<I,I>,Either<I,O>,Automation>{
  private var delegate : Arrowlet<I,Either<O,I>>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
	override public function applyII(i:Either<I,I>,cont:Sink<Either<I,O>>):Automation{
    return switch (i) {
      case Right(v) 	:
        Arrowlet.Apply().postfix(
          (either:Either<O,I>) -> either.flip()
        ).prepare(__.couple(delegate,v),cont);
      case Left(v) 		:
        cont(Left(v));
        Automation.unit();
    }
  }
}