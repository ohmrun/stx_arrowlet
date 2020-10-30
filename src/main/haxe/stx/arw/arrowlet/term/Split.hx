package stx.arw.arrowlet.term;

class Split<I,Oi,Oii,E> extends ArrowletCls<I,Couple<Oi,Oii>,E>{
  var delegate : Arrowlet<Couple<I,I>,Couple<Oi,Oii>,E>;
  
  public function new(lhs,rhs){
    super();
    this.delegate = Arrowlet.lift(new Both(lhs,rhs).asArrowletDef());
  }
  override public function apply(i:I):Couple<Oi,Oii>{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> delegate.apply(__.couple(i,i))
    );
  }
  override public function defer(i:I,cont:Terminal<Couple<Oi,Oii>,E>):Work{
    return delegate.defer(
      __.couple(i,i),
      cont
    );
  }
  override public function get_convention(){
    return this.delegate.convention;
  }
}