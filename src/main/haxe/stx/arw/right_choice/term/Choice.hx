package stx.arw.right_choice.term;

class Choice<I,O,E> extends ArrowletCls<Either<I,I>,Either<I,O>,E>{
  private var delegate : Arrowlet<I,Either<O,I>,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  public function apply(i:Either<I,I>):Either<I,O>{
    return throw E_Arw_IncorrectCallingConvention;
  }
	public function defer(i:Either<I,I>,cont:Terminal<Either<I,O>,E>):Work{
    return switch (i) {
      case Right(v) 	:
        Arrowlet.Applier().postfix(
          (either:Either<O,I>) -> either.flip()
        ).prepare(__.couple(delegate,v),cont);
      case Left(v) 		:
        cont.value(Left(v)).serve();
    }
  }
}