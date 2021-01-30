package stx.arw.arrowlet.term;

class Or<Ii,Iii,O,E> extends ArrowletCls<Either<Ii,Iii>,O,E>{
  private var lhs:Internal<Ii,O,E>;
  private var rhs:Internal<Iii,O,E>;

  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  public inline function apply(i:Either<Ii,Iii>):O{
    return i.fold(lhs.apply,rhs.apply);
  }
  public inline function defer(i:Either<Ii,Iii>,cont:Terminal<O,E>):Work{
    return i.fold(
      (iI)  -> lhs.convention.fold(
        () -> lhs.defer(iI,cont),
        () -> cont.value(lhs.apply(iI)).serve()
      ),
      (iII) -> rhs.convention.fold(
        () -> rhs.defer(iII,cont),
        () -> cont.value(rhs.apply(iII)).serve()
      )
    );
  }
  override public function toString(){
    return 'Or($lhs $rhs)';
  }
}