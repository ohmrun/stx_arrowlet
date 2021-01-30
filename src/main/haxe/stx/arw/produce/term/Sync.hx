package stx.arw.produce.term;

class Sync<O,E> extends ArrowletCls<Noise,Res<O,E>,Noise>{
  public function new(result:Res<O,E>){
    super();
    this.result = result;
  }
  public function defer(_:Noise,cont:Terminal<Res<O,E>,Noise>):Work{
    return cont.value(this.result).serve();
  }
  public function apply(_:Noise){
    return this.result;
  }
  override public function get_convention(){
    return SYNC;
  }
}