package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Then<I,Oi,Oii> extends Base<I,Oii,Automation>{
	private var lhs : Arrowlet<I,Oi>;
	private var rhs : Arrowlet<Oi,Oii>;

  public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function duoply(i:I,cont:Sink<Oii>):Automation{
		return new FlatMap(
			lhs,
			(oI) -> Arrowlet.pure(oI).then(rhs)
		).duoply(i,cont);
	}
}