package stx.arw.arrowlet.term;

class ThenArw<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  static public inline function make<I,Oi,Oii,E>(lhs:I->Oi,rhs:Arrowlet<Oi,Oii,E>):Arrowlet<I,Oii,E>{
    return rhs.toInternal().convention.fold(
      () -> new ThenArw(lhs,rhs).asArrowletDef(),
      () -> new ThenFunFun(lhs,rhs.toInternal().apply).asArrowletDef()
    );
  }
  var lhs : I  -> Oi;
  var rhs : Internal<Oi,Oii,E>;

  private function new(lhs:I -> Oi,rhs:Internal<Oi,Oii,E>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public inline function apply(i:I):Oii{
    return convention.fold(
     () -> return throw E_Arw_IncorrectCallingConvention,
     () -> return this.rhs.apply(this.lhs(i))
    );
  }
  override public function defer(i:I,cont:Terminal<Oii,E>):Work{
    return rhs.defer(lhs(i),cont);
  }
  override public function get_convention(){
    return this.rhs.convention;
  }
}