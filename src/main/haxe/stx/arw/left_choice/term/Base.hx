package stx.arw.left_choice.term;

class Base<Ii,Iii,O,E> extends ArrowletCls<Either<Ii,Iii>,Either<O,Iii>,E>{
  private var delegate : Arrowlet<Ii,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
	}
	public function apply(i:Either<Ii,Iii>):Either<O,Iii>{
    return throw E_Arw_IncorrectCallingConvention;
  }
	public function defer(either:Either<Ii,Iii>,cont:Terminal<Either<O,Iii>,E>):Work{
		return switch (either) {
			case Left(v) 	: Arrowlet.Applier().then(Left).prepare(__.couple(delegate,v),cont);
			case Right(v) : 
				cont.value(Right(v)).serve();
		}
	}
}