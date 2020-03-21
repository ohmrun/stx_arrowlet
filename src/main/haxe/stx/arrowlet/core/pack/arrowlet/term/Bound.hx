package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Bound<I,Oi,Oii> extends Base<I,Oii,Automation>{
  var lhs : Arrowlet<I,Oi>;
  var rhs : Arrowlet<Couple<I,Oi>,Oii>;
  public function new(lhs:Arrowlet<I,Oi>,rhs:Arrowlet<Couple<I,Oi>,Oii>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function applyII(i:I,cont:Sink<Oii>):Automation{
    return new FlatMap(
      lhs,
      (oI) -> Arrowlet.pure(__.couple(i,oI)).then(rhs)
    ).applyII(i,cont);
  }
}