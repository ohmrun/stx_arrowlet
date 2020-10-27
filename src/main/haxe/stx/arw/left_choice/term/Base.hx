package stx.arw.left_choice.term;

class Base<Ii,Iii,O,E> extends ArrowletBase<Either<Ii,Iii>,Either<O,Iii>,E>{
  private var delegate : Arrowlet<Ii,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
	}
	override public function applyII(either:Either<Ii,Iii>,cont:Terminal<Either<O,Iii>,E>):Work{
		return switch (either) {
			case Left(v) 	: Arrowlet.Applier().then(Left).prepare(__.couple(delegate,v),cont);
			case Right(v) : 
				cont.value(Right(v)).serve();
		}
	}
}