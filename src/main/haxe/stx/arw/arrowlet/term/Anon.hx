package stx.arw.arrowlet.term;

class Anon<I,O,E> extends ArrowletBase<I,O,E>{
  private var delegate : I->Terminal<O,E>->Work;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:I,cont:Terminal<O,E>):Work{
    return delegate(i,cont);
  }
}
