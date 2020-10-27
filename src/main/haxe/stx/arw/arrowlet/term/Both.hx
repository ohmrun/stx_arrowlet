package stx.arw.arrowlet.term;

/**
	* Runs the `lhs` and `rhs` concurrently.
**/
class Both<Ii,Oi,Iii,Oii,E> extends ArrowletBase<Couple<Ii,Iii>,Couple<Oi,Oii>,E>{

	private var lhs : Arrowlet<Ii,Oi,E>;
	private var rhs : Arrowlet<Iii,Oii,E>;

	public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function applyII(i:Couple<Ii,Iii>,cont:Terminal<Couple<Oi,Oii>,E>):Work{
		var future 		= Future.trigger();
		var defer 		= cont.defer(future);
		var l_val			= None;
		var r_val			= None;

		var guard 		= () -> {
			switch([l_val,r_val]){
				case [Some(Failure(x)),None]  						: 
					future.trigger(Failure(x));//TODO does it get here?
				case [None,Some(Failure(x))]  						: 
					future.trigger(Failure(x));
				case [Some(Success(l)),Some(Success(r))] 	:
					future.trigger(Success(__.couple(l,r)));
				default : 
			}
		};
		var l_set 		= cont.inner(
					(oi:Outcome<Oi,E>)		-> { 
						l_val = Some(oi); 	
						guard(); 	
					}
				);
		var r_set 		= cont.inner(
					(oii:Outcome<Oii,E>)	-> { 
						r_val = Some(oii);	
						guard(); 
					}
				);

		var l_task 		= lhs.prepare(i.fst(),l_set);
		var r_task 		= rhs.prepare(i.snd(),r_set);
		
		return defer.after(l_task.par(r_task));
	}
}