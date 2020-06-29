package stx.arrowlet.core.pack.arrowlet.term;

class Or<Ii,Iii,O,E> extends ArrowletBase<Either<Ii,Iii>,O,E>{
  private var lhs:Arrowlet<Ii,O,E>;
  private var rhs:Arrowlet<Iii,O,E>;

  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override private function doApplyII(i:Either<Ii,Iii>,cont:Terminal<O,E>):Work{
    return i.fold(
      (iI)  -> lhs.prepare(iI,cont),
      (iII) -> rhs.prepare(iII,cont)
    );
  }
}