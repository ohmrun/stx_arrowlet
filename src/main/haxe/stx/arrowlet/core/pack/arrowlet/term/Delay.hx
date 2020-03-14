package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Delay<I> extends Base<I,I,Automation>{
  private var milliseconds : Int;
  public function new(milliseconds){
    super();
    this.milliseconds = milliseconds;
  }
  override public function duoply(i:I,cont:Sink<I>):Automation{
    Act.Delay(milliseconds).upply(
      () -> cont(i)
    );
    return Automation.unit();
  }
}