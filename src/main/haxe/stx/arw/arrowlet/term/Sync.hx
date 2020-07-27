package stx.arw.arrowlet.term;

class Sync<I,O,E> extends ArrowletBase<I,O,E>{
  private var delegate : I->O;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:I,cont:Terminal<O,E>):Work{
    return cont.value(delegate(i)).serve();
  }
}