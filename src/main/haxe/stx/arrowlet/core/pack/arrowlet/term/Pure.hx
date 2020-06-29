package stx.arrowlet.core.pack.arrowlet.term;

class Pure<I,O,E> extends ArrowletBase<I,O,E>{
  private var secreted : O;
  public function new(secreted){
    super();
    this.secreted = secreted;
  }
  override private function doApplyII(i:I,cont:Terminal<O,E>):Work{
    return cont.value(secreted).serve();
  }
}