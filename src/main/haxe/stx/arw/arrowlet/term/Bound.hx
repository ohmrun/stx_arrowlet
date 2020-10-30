package stx.arw.arrowlet.term;

class Bound<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  var lhs : Arrowlet<I,Oi,E>;
  var rhs : Arrowlet<Couple<I,Oi>,Oii,E>;
  public function new(lhs:Arrowlet<I,Oi,E>,rhs:Arrowlet<Couple<I,Oi>,Oii,E>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function apply(i:I):Oii{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> rhs.apply(__.couple(i,lhs.apply(i)))
    );
  }
  override public function defer(i:I,cont:Terminal<Oii,E>):Work{
    return new FlatMap(
      lhs,
      (oI) -> Arrowlet.pure(__.couple(i,oI)).then(rhs)
    ).defer(i,cont);
  }
}