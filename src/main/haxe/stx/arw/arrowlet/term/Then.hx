package stx.arw.arrowlet.term;

class Then<I,Oi,Oii,E> extends ArrowletBase<I,Oii,E>{
	private var lhs : Arrowlet<I,Oi,E>;
	private var rhs : Arrowlet<Oi,Oii,E>;

  public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public inline function applyII(i:I,cont:Terminal<Oii,E>):Work{
		return switch(lhs.status){
			case Problem : cont.error(lhs.defect).serve();
			case Pending | Working | Waiting : 
				var later = Future.trigger();
				var inner = cont.inner(
					(outcome:Outcome<Oi,E>) -> {
						var later_work = outcome.fold(
							(ok) -> handle_rhs(rhs,ok,cont),
							(no) -> cont.error(no).serve()
						);
						later.trigger(later_work);
					}
				);
				return lhs.toWork().seq(later.asFuture());
			case Secured:
				handle_rhs(rhs,lhs.result,cont);
			case Applied: 
				handle_rhs(rhs,lhs.apply(i),cont);
		}
	}
	private function handle_rhs(rhs:Arrowlet<Oi,Oii,E>,i:Oi,cont:Terminal<Oii,E>):Work{
		return switch(rhs.status){
			case Problem : 
				cont.error(rhs.defect).serve();
			case Secured : 
				cont.value(rhs.result).serve();
			case Pending | Working | Waiting : 			
				var defer 								= Future.trigger();
				rhs.applyII(i,cont);
			case Applied : 
				cont.value(rhs.apply(i)).serve();
		}
	}
}