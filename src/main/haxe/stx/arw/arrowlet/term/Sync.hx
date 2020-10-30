package stx.arw.arrowlet.term;

class Sync<I,O,E> extends ArrowletCls<I,O,E>{
  private var input       : I;
  private var inner       : I->O;
  public function new(inner){
    super();
    this.status     = Applied;
    this.inner      = inner;
  }
  override public inline function apply(v:I){
    return this.inner(v);
  }
  override public inline function pursue():Void{}
  override public inline function defer(i:I,cont:Terminal<O,E>):Work{
    return cont.value(inner(i)).serve();
  }
  override public function get_convention(){
    return SYNC;
  }
}