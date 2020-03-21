package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Then<I,Oi,Oii> extends Base<I,Oii,Automation>{
	private var lhs : ArrowletDef<I,Oi>;
	private var rhs : ArrowletDef<Oi,Oii>;

  public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function applyII(i:I,cont:Sink<Oii>):Automation{
		return new FlatMap(
			lhs,
			(oI) -> Arrowlet.lift(
				Recall.Anon((_:I,cont:Sink<Oii>) -> rhs.applyII(oI,cont))
			)
		).applyII(i,cont);
	}
}