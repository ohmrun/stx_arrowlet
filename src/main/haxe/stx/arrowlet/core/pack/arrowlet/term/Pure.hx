package stx.arrowlet.core.pack.arrowlet.term;

class Pure<I,O,E> extends ArrowletApi<I,O,E>{
  private var secreted : O;
  public function new(secreted){
    super();
    this.secreted = secreted;
  }
  override private function doApplyII(i:I,cont:Terminal<O,E>):Response{
    cont.value(secreted);
    return cont.serve();
  }
}