package stx.arw.left_choice.term;

class Choice<I,O,E> extends ArrowletCls<Either<I,I>,Either<O,I>,E>{
  private var delegate : Arrowlet<I,Either<O,I>,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function apply(i:Either<I,I>):Either<O,I>{
    return throw E_Arw_IncorrectCallingConvention;
  }
	public function defer(either:Either<I,I>,cont:Terminal<Either<O,I>,E>):Work{
    return switch(either){
      case Left(i)      : Arrowlet.Applier().prepare(__.couple(delegate,i),cont);
      case Right(oii)   : 
        cont.value(Right(oii)).serve();
    }
  }
}