package stx.arrowlet.core.pack.left_choice.term;

class Base<Ii,Iii,O,E> extends ArrowletApi<Either<Ii,Iii>,Either<O,Iii>,E>{
  private var delegate : Arrowlet<Ii,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
	}
	override private function doApplyII(either:Either<Ii,Iii>,cont:Terminal<Either<O,Iii>,E>):Work{
		return switch (either) {
			case Left(v) 	: Arrowlet.Apply().then(Left).prepare(__.couple(delegate,v),cont);
			case Right(v) : 
				cont.value(Right(v)).serve();
		}
	}
}