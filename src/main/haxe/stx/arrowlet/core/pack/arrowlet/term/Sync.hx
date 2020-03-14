package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Sync<I,O> extends Base<I,O,Automation>{
  private var delegate : I->O;
  public function new(delegate){
    super();
    this.delegate = delegate;
  }
  override public function duoply(i:I,cont:Sink<O>):Automation{
    cont(delegate(i));
    return Automation.inj().unit();
  }
}