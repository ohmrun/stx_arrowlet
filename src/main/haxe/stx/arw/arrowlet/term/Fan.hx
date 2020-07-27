package stx.arw.arrowlet.term;

class Fan<I,O,E> extends ArrowletBase<I,Couple<O,O>,E>{
  private var delegate : Arrowlet<I,O,E>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override private function doApplyII(i:I,cont:Terminal<Couple<O,O>,E>):Work{
    var future = TinkFuture.trigger();
    var inner = cont.inner(
      (o:Outcome<O,E>) -> future.trigger(o.map(v -> __.couple(v,v)))
    );
    return cont.defer(future).after(delegate.prepare(i,inner));
  }
}