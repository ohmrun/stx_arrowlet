package stx.arw.provide.term;

class Sync<O> extends ArrowletCls<Noise,O,Noise>{
  public function new(result:O){
    super();
    this.result = result;
  }
  public function defer(_:Noise,cont:Terminal<O,Noise>):Work{
    return cont.value(this.result).serve();
  }
  public function apply(_:Noise){
    return this.result;
  }
  override public function get_convention(){
    return SYNC;
  }
}