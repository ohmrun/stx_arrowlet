package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Split<I,Oi,Oii> extends Base<I,Tuple2<Oi,Oii>,Automation>{
  var delegate : Arrowlet<Tuple2<I,I>,Tuple2<Oi,Oii>>;
  
  public function new(lhs,rhs){
    super();
    this.delegate = Arrowlet.lift(new Both(lhs,rhs).asRecallDef());
  }
  override public function duoply(i:I,cont:Sink<Tuple2<Oi,Oii>>):Automation{
    return delegate.duoply(
      tuple2(i,i),
      cont
    );
  }
}