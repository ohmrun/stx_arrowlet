package stx.arrowlet.core.pack.right_choice.term;

class Base<Ii,O,Iii,E> extends ArrowletBase<Either<Iii,Ii>,Either<Iii,O>,E>{
  private var delegate : Arrowlet<Ii,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
	override private function doApplyII(i:Either<Iii,Ii>,cont:Terminal<Either<Iii,O>,E>):Work{
    return switch (i) {
      case Right(v) 	:
        Arrowlet.Apply().then(Right).prepare(__.couple(delegate,v),cont);
      case Left(v) 		:
        cont.value(Left(v)).serve();
    }
  }
}