package stx.arrowlet.core.pack.arrowlet.term;

class Bound<I,Oi,Oii,E> extends ArrowletApi<I,Oii,E>{
  var lhs : Arrowlet<I,Oi,E>;
  var rhs : Arrowlet<Couple<I,Oi>,Oii,E>;
  public function new(lhs:Arrowlet<I,Oi,E>,rhs:Arrowlet<Couple<I,Oi>,Oii,E>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override private function doApplyII(i:I,cont:Terminal<Oii,E>):Response{
    return new FlatMap(
      lhs,
      (oI) -> Arrowlet.pure(__.couple(i,oI)).then(rhs)
    ).applyII(i,cont);
  }
}