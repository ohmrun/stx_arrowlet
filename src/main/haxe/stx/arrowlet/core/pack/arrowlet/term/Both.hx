package stx.arrowlet.core.pack.arrowlet.term;

class Both<Ii,Oi,Iii,Oii,E> extends ArrowletApi<Couple<Ii,Iii>,Couple<Oi,Oii>,E>{

	private var lhs : Arrowlet<Ii,Oi,E>;
	private var rhs : Arrowlet<Iii,Oii,E>;

	public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override private function doApplyII(i:Couple<Ii,Iii>,cont:Terminal<Couple<Oi,Oii>,E>):Response{
		var l_val			= None;
		var r_val			= None;
		var l_cancel	= () -> {};
		var r_cancel	= () -> {};

		var guard 		= () -> {
			switch([l_val,r_val]){
				case [Some(Failure(x)),None]  						: 
					r_cancel();
					cont.error(x);
				case [None,Some(Failure(x))]  						: 
					l_cancel();
					cont.error(x);
				case [Some(Success(l)),Some(Success(r))] 	:
					cont.value(__.couple(l,r));
				default : 
			}
		};
		var l_set 		= cont.inner();
				l_set.later(
					(oi:Outcome<Oi,E>)		-> { 
						l_val = Some(oi); 	
						guard(); 	
					}
				);
		var r_set 		= cont.inner();
				r_set.later(
					(oii:Outcome<Oii,E>)	-> { 
						r_val = Some(oii);	
						guard(); 
					}
				);

		var l_task 		= lhs.prepare(i.fst(),l_set);
		var l_cancel	= l_task.toTask().escape;
		var r_task 		= rhs.prepare(i.snd(),r_set);
		var r_cancel	= r_task.toTask().escape;
		cont.after(l_task);
		cont.after(r_task);
		return cont.serve();
	}
}