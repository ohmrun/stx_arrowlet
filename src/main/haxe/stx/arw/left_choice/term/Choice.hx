package stx.arw.left_choice.term;

class Choice<I,O,E> extends ArrowletBase<Either<I,I>,Either<O,I>,E>{
  private var delegate : Arrowlet<I,Either<O,I>,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
	}
	override public function applyII(either:Either<I,I>,cont:Terminal<Either<O,I>,E>):Work{
    return switch(either){
      case Left(i)      : Arrowlet.Applier().prepare(__.couple(delegate,i),cont);
      case Right(oii)   : 
        cont.value(Right(oii)).serve();
    }
  }
}