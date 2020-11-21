package stx.arw.right_choice.term;

class Base<Ii,O,Iii,E> extends ArrowletCls<Either<Iii,Ii>,Either<Iii,O>,E>{
  private var delegate : Internal<Ii,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override inline public function apply(i:Either<Iii,Ii>):Either<Iii,O>{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> i.fold(
        (l) -> __.left(l),
        (r) -> __.right(delegate.apply(r))
      )
    );
  }
	override inline public function defer(i:Either<Iii,Ii>,cont:Terminal<Either<Iii,O>,E>):Work{
    return switch (i) {
      case Right(v) 	: Arrowlet.Applier().then(Right).prepare(__.couple(delegate.toArrowlet(),v),cont);
      case Left(v) 		: cont.value(Left(v)).serve();
    }
  }
  override public function get_convention(){
    return this.delegate.convention;
  }
}
