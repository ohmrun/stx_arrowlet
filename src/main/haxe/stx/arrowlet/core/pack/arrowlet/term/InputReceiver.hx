package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class InputReceiver<I,O> extends Base<I,O,Automation>{
  private var delegate : I->Receiver<O>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:I,cont:Sink<O>):Automation{
    return delegate(i).duoply(Noise,cont);
  }
}
