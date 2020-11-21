package stx.arw.provide.term;

class Thunk<O> extends ArrowletCls<Noise,O,Noise>{
  var delegate    : Void->O;
  var initialized : Bool;

  public function new(delegate){
    super();
    this.delegate     = delegate;
    this.initialized  = false;
  }
  inline function initialize(){
    if(!initialized){
      initialized = true;
      this.result = delegate();
    }
  }
  override inline public function apply(p:Noise):O{
    initialize();
    return result;
  }
  override inline public function defer(p:Noise,cont:Terminal<O,Noise>):Work{
    return cont.value(apply(p)).serve();
  }
  override public function get_convention(){
    return SYNC;
  }
  override public function pursue(){
    initialize();
    super.pursue();
  }
}