package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Pure<I,O> extends Base<I,O,Automation>{
  private var secreted : O;
  public function new(secreted){
    super();
    this.secreted = secreted;
  }
  override public function applyII(i:I,cont:Sink<O>):Automation{
    cont(secreted);
    return Automation.unit();
  }
}