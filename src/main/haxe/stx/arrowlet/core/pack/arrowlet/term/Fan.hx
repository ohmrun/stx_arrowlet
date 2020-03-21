package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Fan<I,O> extends Base<I,Couple<O,O>,Automation>{
  private var delegate : Arrowlet<I,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function applyII(i:I,cont:Sink<Couple<O,O>>):Automation{
    return delegate.applyII(
      i,
      (o) -> cont(__.couple(o,o))
    );
  }
}