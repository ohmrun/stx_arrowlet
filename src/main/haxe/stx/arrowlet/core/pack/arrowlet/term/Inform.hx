package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Inform<I,Oi,Oii> extends Base<I,Oii,Automation>{
  var lhs : Arrowlet<I,Oi>;
  var rhs : Arrowlet<Oi,Arrowlet<Oi,Oii>>;
  public function new(lhs,rhs){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function applyII(i:I,cont:Sink<Oii>):Automation{
    return lhs.flat_map(
      (oI) -> Arrowlet.fromRecallFun(
        (_:I,contI:Sink<Oii>) -> rhs.flat_map(
          (aOiOii) -> aOiOii
        ).applyII(oI,contI)
      )
    ).applyII(i,cont);
  }
}