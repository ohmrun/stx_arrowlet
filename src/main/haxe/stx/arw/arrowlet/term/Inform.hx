package stx.arw.arrowlet.term;

class Inform<I,Oi,Oii,E> extends ArrowletBase<I,Oii,E>{
  var lhs : Arrowlet<I,Oi,E>;
  var rhs : Arrowlet<Oi,Arrowlet<Oi,Oii,E>,E>;
  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override private function doApplyII(i:I,cont:Terminal<Oii,E>):Work{
    return lhs.flat_map(
      (oI) -> Arrowlet.Anon(
        (_:I,contI:Terminal<Oii,E>) -> rhs.flat_map(
          (aOiOii) -> aOiOii
        ).applyII(oI,contI)
      )
    ).applyII(i,cont);
  }
}