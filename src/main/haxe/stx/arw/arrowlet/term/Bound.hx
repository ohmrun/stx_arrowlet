package stx.arw.arrowlet.term;

class Bound<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  var lhs : Internal<I,Oi,E>;
  var rhs : Internal<Couple<I,Oi>,Oii,E>;
  
  public function new(lhs:Internal<I,Oi,E>,rhs:Internal<Couple<I,Oi>,Oii,E>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  public function apply(i:I):Oii{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> rhs.apply(__.couple(i,lhs.apply(i)))
    );
  }
  public function defer(i:I,cont:Terminal<Oii,E>):Work{
    return new FlatMap(
      lhs,
      (oI) -> Arrowlet.pure(__.couple(i,oI)).then(rhs.toArrowlet())
    ).defer(i,cont);
  }
}