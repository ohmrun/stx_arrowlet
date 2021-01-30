package stx.arw.arrowlet.term;

class ThenFunFun<P,Oi,Oii,E> extends ArrowletCls<P,Oii,E>{
  var lhs : P -> Oi;
  var rhs : Oi -> Oii;
  public function new(lhs:P -> Oi,rhs:Oi -> Oii){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  public function defer(p:P,cont:Terminal<Oii,E>){
    return cont.value(apply(p)).serve();
  }
  inline public function apply(p:P):Oii{
    return rhs(lhs(p));
  }
  public function next<Oiii>(that:Oii->Oiii):ThenFunFun<P,Oii,Oiii,E>{
    return new ThenFunFun(this.apply,that);
  }
  override public function toString(){
    return 'ThenFunFun($lhs,$rhs)';
  }
}