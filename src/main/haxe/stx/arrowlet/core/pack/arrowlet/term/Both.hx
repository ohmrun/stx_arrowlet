package stx.arrowlet.core.pack.arrowlet.term;

import stx.run.pack.recall.term.Base;

class Both<Ii,Oi,Iii,Oii> extends Base<Couple<Ii,Iii>,Couple<Oi,Oii>,Automation>{

	private var lhs : Arrowlet<Ii,Oi>;
	private var rhs : Arrowlet<Iii,Oii>;

	public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function applyII(i:Couple<Ii,Iii>,cont:Sink<Couple<Oi,Oii>>):Automation{
		var l_val			= None;
		var r_val			= None;

		var guard 		= () -> {
			l_val.zip(r_val).fold(cont,()->{});
		}
		var l_set 		= (oi:Oi)		-> { l_val = Some(oi); 	guard(); }
		var r_set 		= (oii:Oii)	-> { r_val = Some(oii);	guard(); }

		var l_task 		= lhs.prepare(i.fst(),l_set);
		var r_task 		= rhs.prepare(i.snd(),r_set);

		return Task.All([l_task,r_task].toIter().toGenerator());
	}
}