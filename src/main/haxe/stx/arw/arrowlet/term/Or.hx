package stx.arw.arrowlet.term;

class Or<Ii,Iii,O,E> extends ArrowletCls<Either<Ii,Iii>,O,E>{
  private var lhs:Arrowlet<Ii,O,E>;
  private var rhs:Arrowlet<Iii,O,E>;

  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function apply(i:Either<Ii,Iii>):O{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function defer(i:Either<Ii,Iii>,cont:Terminal<O,E>):Work{
    return i.fold(
      (iI)  -> lhs.prepare(iI,cont),
      (iII) -> rhs.prepare(iII,cont)
    );
  }
}