package stx.arrowlet.core.pack.left_choice.term;

import stx.run.pack.recall.term.Base in RecallBase;

class Base<Ii,Iii,O> extends RecallBase<Either<Ii,Iii>,Either<O,Iii>,Automation>{
  private var delegate : Arrowlet<Ii,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
	}
	override public function applyII(either:Either<Ii,Iii>,cont:Sink<Either<O,Iii>>):Automation{
		return switch (either) {
			case Left(v) 	: Arrowlet.Apply().then(Left).prepare(__.couple(delegate,v),cont);
			case Right(v) : 
				cont(Right(v)); 
				Automation.unit();
		}
	}
}