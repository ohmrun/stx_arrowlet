package stx.arw.arrowlet.term;

class Sync<P,O,E> extends ArrowletCls<P,O,E>{
  var delegate : P -> O;
  public function new(delegate:P->O){
    super();
    this.set_status(Applied);
    this.delegate   = delegate;
  }
  inline public function apply(p:P):O{
    return delegate(p);
  }
  override public inline function pursue():Void{
    super.pursue();
  }
  public inline function defer(p:P,cont:Terminal<O,E>):Work{
    return cont.value(apply(p)).serve();
  }
  override public function get_convention() return SYNC;
  
  public function next<Oi>(that:O->Oi):ThenFunFun<P,O,Oi,E>{
    return new ThenFunFun(apply,that);
  }
  override public function toString(){
    return 'Sync()';
  }
}