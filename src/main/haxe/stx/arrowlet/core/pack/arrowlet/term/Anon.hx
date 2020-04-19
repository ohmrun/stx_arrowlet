package stx.arrowlet.core.pack.arrowlet.term;

class Anon<I,O,E> extends ArrowletApi<I,O,E>{
  private var delegate : I->Terminal<O,E>->Response;

  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:I,cont:Terminal<O,E>):Response{
    return delegate(i,cont);
  }
}