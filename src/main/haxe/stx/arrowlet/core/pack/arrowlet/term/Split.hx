package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Split<I,Oi,Oii> extends Base<I,Couple<Oi,Oii>,Automation>{
  var delegate : Arrowlet<Couple<I,I>,Couple<Oi,Oii>>;
  
  public function new(lhs,rhs){
    super();
    this.delegate = Arrowlet.lift(new Both(lhs,rhs).asRecallDef());
  }
  override public function applyII(i:I,cont:Sink<Couple<Oi,Oii>>):Automation{
    return delegate.applyII(
      __.couple(i,i),
      cont
    );
  }
}