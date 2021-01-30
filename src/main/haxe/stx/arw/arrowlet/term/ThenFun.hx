package stx.arw.arrowlet.term;

class ThenFun<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  static public inline function make<I,Oi,Oii,E>(lhs:Internal<I,Oi,E>,rhs:Oi->Oii){
    return new ThenFun(lhs,rhs);
  }
  var lhs : Internal<I,Oi,E>;
  var rhs : Oi -> Oii;

  public function new(lhs:Internal<I,Oi,E>,rhs:Oi->Oii){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  public inline function apply(i:I):Oii{
    return this.rhs(this.lhs.apply(i));
  }
  public inline function defer(i:I,cont:Terminal<Oii,E>):Work{
    return lhs.defer(i,cont.joint(joint.bind(_,cont)));
  }
  private function joint(outcome:Outcome<Oi,Defect<E>>,cont:Terminal<Oii,E>){
    return cont.issue(outcome.map((ok) -> rhs(ok))).serve();
  }
  override public function get_convention(){
    return this.lhs.convention;
  }
  override public function toString(){
    var n = this.identifier().name;
    return '$n($lhs -> $rhs)';
  }
}