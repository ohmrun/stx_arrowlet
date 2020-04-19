package stx.arrowlet.core.pack.arrowlet.term;

class Handler<O,E> extends ArrowletApi<Noise,O,E>{
  var delegate : (O->Void)->Void;
  public function new(delegate:(O->Void)->Void){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:Noise,cont:Terminal<O,E>):Response{
    delegate(cont.value);
    return cont.serve();
  }
}