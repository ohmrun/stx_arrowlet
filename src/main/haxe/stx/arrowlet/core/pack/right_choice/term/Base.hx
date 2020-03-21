package stx.arrowlet.core.pack.right_choice.term;

import stx.run.pack.recall.term.Base in RecallBase;

class Base<Ii,O,Iii> extends RecallBase<Either<Iii,Ii>,Either<Iii,O>,Automation>{
  private var delegate : Arrowlet<Ii,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
	override public function applyII(i:Either<Iii,Ii>,cont:Sink<Either<Iii,O>>):Automation{
    return switch (i) {
      case Right(v) 	:
        Arrowlet._().Apply().then(Right).prepare(__.couple(delegate,v),cont);
      case Left(v) 		:
        cont(Left(v));
        return Automation.unit();
    }
  }
}