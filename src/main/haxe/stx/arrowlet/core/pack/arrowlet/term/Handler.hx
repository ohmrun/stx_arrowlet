package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Handler<O> extends Base<Noise,O,Automation>{
  var delegate : (O->Void)->Void;
  public function new(delegate:(O->Void)->Void){
    super();
    this.delegate = delegate;
  }
  override public function applyII(i:Noise,cont:O->Void):Automation{
    delegate(cont);
    return Automation.unit();
  }
}