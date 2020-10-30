package stx.arw.arrowlet.term;

class Then<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
	private var lhs : Arrowlet<I,Oi,E>;
	private var rhs : Arrowlet<Oi,Oii,E>;

  public function new(lhs,rhs){
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
				var later = Future.trigger();
				var inner = cont.inner(
					(outcome:Outcome<Oi,Defect<E>>) -> {
						var later_work = outcome.fold(
							(ok) -> handle_rhs(rhs,ok,cont),
							(no) -> cont.error(no).serve()
						);
						later.trigger(later_work);
					}
				);
				return lhs.defer(i,inner).seq(later);
			case Secured: handle_rhs(rhs,lhs.result,cont);
			case Applied: handle_rhs(rhs,lhs.apply(i),cont);
		}
	}
	private inline function handle_rhs(rhs:Arrowlet<Oi,Oii,E>,i:Oi,cont:Terminal<Oii,E>):Work{
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