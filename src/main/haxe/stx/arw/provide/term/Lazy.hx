package stx.arw.provide.term;

class Lazy<O> extends ArrowletCls<Noise,O,Noise>{
  var thunk       : Void->Provide<O>;
  var delegate    : Provide<O>;
  var initialized : Bool;
  
  public inline function new(thunk){
    this.thunk        = thunk;
    this.initialized  = false;
  }
  private inline function initialize(){
    if(!initialize){
      this.initialized  = true;
      this.delegate     = thunk(); 
    }
  }
  override inline public function apply(p:Noise):O{
    initialize();
    return delegate.toInternal().apply(p);
  }
  override inline public function defer(p:Noise,cont:Terminal<O,Noise>):Work{
    initialize();
    return delegate.toInternal().defer(p,cont);
  }
  override public function get_convention(){
    initialize();
    return delegate.convention;
  }
}