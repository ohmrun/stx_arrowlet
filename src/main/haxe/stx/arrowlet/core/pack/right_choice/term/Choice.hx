package stx.arrowlet.core.pack.right_choice.term;

class Choice<I,O,E> extends ArrowletBase<Either<I,I>,Either<I,O>,E>{
  private var delegate : Arrowlet<I,Either<O,I>,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
	override private function doApplyII(i:Either<I,I>,cont:Terminal<Either<I,O>,E>):Work{
    return switch (i) {
      case Right(v) 	:
        Arrowlet.Apply().postfix(
          (either:Either<O,I>) -> either.flip()
        ).prepare(__.couple(delegate,v),cont);
      case Left(v) 		:
        cont.value(Left(v)).serve();
    }
  }
}