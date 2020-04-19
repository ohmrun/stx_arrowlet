package stx.arrowlet.core.pack.arrowlet.term;

class Fan<I,O,E> extends ArrowletApi<I,Couple<O,O>,E>{
  private var delegate : Arrowlet<I,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:I,cont:Terminal<Couple<O,O>,E>):Response{
    var inner = cont.inner();
        inner.later(
          (o:Outcome<O,E>) -> cont.issue(o.map(v -> __.couple(v,v)))
        );
    return delegate.prepare(i,inner);
  }
}