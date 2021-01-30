package stx.arw.arrowlet.term;

class SplitArw<I,Oi,Oii,E> extends ArrowletCls<I,Couple<Oi,Oii>,E>{
  
  public var lhs(default,null):I->Oi;
  public var rhs(default,null):Internal<I,Oii,E>;

  public function new(lhs:I->Oi,rhs:Internal<I,Oii,E>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  public function apply(p:I):Couple<Oi,Oii>{
    return __.couple(lhs(p),rhs.apply(p));
  }
  public function defer(p:I,cont:Terminal<Couple<Oi,Oii>,E>):Work{
    return ThenFun.make(rhs,__.couple.bind(lhs(p))).defer(p,cont);
  }
  override public function get_convention(){
    return this.rhs.convention;
  }
}