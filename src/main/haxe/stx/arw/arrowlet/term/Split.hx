package stx.arw.arrowlet.term;

class Split<I,Oi,Oii,E> extends ArrowletCls<I,Couple<Oi,Oii>,E>{
  
  public var lhs(default,null):Internal<I,Oi,E>;
  public var rhs(default,null):Internal<I,Oii,E>;

  public function new(lhs,rhs){
    super();
    this.lhs      = lhs;
    this.rhs      = rhs;
  }
  override public function apply(i:I):Couple<Oi,Oii>{
    return convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> __.couple(lhs.apply(i),rhs.apply(i))
    );
  }
  override public function defer(i:I,cont:Terminal<Couple<Oi,Oii>,E>):Work{
    return Both.make(lhs,rhs).defer(__.couple(i,i),cont);
  }
  override public function get_convention(){
    return this.lhs.convention || this.rhs.convention;
  }
}