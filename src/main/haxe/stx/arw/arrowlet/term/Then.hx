package stx.arw.arrowlet.term;

class Then<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
	private var lhs : Internal<I,Oi,E>;
	private var rhs : Internal<Oi,Oii,E>;

  public function new(lhs:Internal<I,Oi,E>,rhs:Internal<Oi,Oii,E>){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function apply(i:I):Oii{
    return rhs.apply(lhs.apply(i));
  }
	override public inline function defer(i:I,cont:Terminal<Oii,E>):Work{
		return switch(lhs.status){
			case Problem : cont.error(lhs.defect).serve();
			case Pending | Working | Waiting  : 
				lhs.defer(
					i,
					cont.joint(joint.bind(_,cont))
				);
			case Secured: handle_rhs(lhs.result,cont);
			case Applied: handle_rhs(lhs.apply(i),cont);
		}
	}
	private function joint(outcome:Outcome<Oi,Defect<E>>,cont:Terminal<Oii,E>):Work{
		return outcome.fold(
			(ok) -> handle_rhs(ok,cont),
			(no) -> cont.error(no).serve()
		);
	}
	private inline function handle_rhs(i:Oi,cont:Terminal<Oii,E>):Work{
		return switch(rhs.status){
			case Problem 										 	: cont.error(rhs.defect).serve();
			case Secured 										 	: cont.value(rhs.result).serve();
			case Pending | Working | Waiting 	:	rhs.defer(i,cont);
			case Applied 											: cont.value(rhs.apply(i)).serve();
		}
	}
	override public function get_convention(){
		return this.lhs.convention || this.rhs.convention;
	}
}