package stx.arw.produce.term;

class Thunk<O,E> extends ArrowletCls<Noise,Res<O,E>,Noise>{
  var thunk : stx.fn.Thunk<Res<O,E>>;
  public function new(thunk:stx.fn.Thunk<Res<O,E>>){
    super();
    this.thunk = thunk;
  }
  inline public function defer(_:Noise,cont:Terminal<Res<O,E>,Noise>):Work{
    return cont.value(apply(_)).serve();
  }
  inline public function apply(_:Noise):Res<O,E>{
    return this.result = thunk();
  }
  override public function get_convention(){
    return SYNC;
  }
}