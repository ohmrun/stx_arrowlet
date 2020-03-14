package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class InputReactor<I,O> extends Base<I,O,Automation>{
  private var delegate : RecallFun<I,O,Void>;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:I,cont:Sink<O>):Automation{
    delegate(i,cont);
    return Automation.inj().unit();
  }
}