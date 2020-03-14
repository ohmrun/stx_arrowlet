package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Bound<I,Oi,Oii> extends Base<I,Oii,Automation>{
  var lhs : Arrowlet<I,Oi>;
  var rhs : Arrowlet<Tuple2<I,Oi>,Oii>;
  public function new(lhs:Arrowlet<I,Oi>,rhs:Arrowlet<Tuple2<I,Oi>,Oii>){
    super();
    this.lhs = lhs;
    this.rhs = rhs;
  }
  override public function duoply(i:I,cont:Sink<Oii>):Automation{
    return new FlatMap(
      lhs,
      (oI) -> Arrowlet.pure(Tuple2.lift(tuple2(i,oI))).then(rhs)
    ).duoply(i,cont);
  }
}