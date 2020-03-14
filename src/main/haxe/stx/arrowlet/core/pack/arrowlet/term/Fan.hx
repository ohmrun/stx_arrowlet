package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Fan<I,O> extends Base<I,Tuple2<O,O>,Automation>{
  private var delegate : Arrowlet<I,O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:I,cont:Sink<Tuple2<O,O>>):Automation{
    return delegate.duoply(
      i,
      (o) -> cont(tuple2(o,o))
    );
  }
}