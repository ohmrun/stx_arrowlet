package stx.arw.arrowlet.term;

/**
	* Runs the `lhs` and `rhs` concurrently.
**/
class Both<Ii,Oi,Iii,Oii,E> extends ArrowletCls<Couple<Ii,Iii>,Couple<Oi,Oii>,E>{

	private var lhs : Arrowlet<Ii,Oi,E>;
	private var rhs : Arrowlet<Iii,Oii,E>;

	public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function apply(i:Couple<Ii,Iii>):Couple<Oi,Oii>{
		return this.convention.fold(
			() -> throw E_Arw_IncorrectCallingConvention,
			() -> __.couple(this.lhs.apply(i.fst()),this.rhs.apply(i.snd()))
		);
	}
	override public function defer(i:Couple<Ii,Iii>,cont:Terminal<Couple<Oi,Oii>,E>):Work{
		return switch([lhs.status,rhs.status]){
			case [Applied,Applied] 	:	cont.value(__.couple(lhs.apply(i.fst()),rhs.apply(i.snd()))).serve();
			case [Secured,Secured]	: cont.value(__.couple(lhs.result,rhs.result)).serve();
			case [Applied,Secured]	: cont.value(__.couple(lhs.apply(i.fst()),rhs.result)).serve();
			case [Secured,Applied]	: cont.value(__.couple(lhs.result,rhs.apply(i.snd()))).serve();
			case [Problem,_]				: cont.error(lhs.defect).serve();
			case [_,Problem]				: cont.error(rhs.defect).serve();
			default :
				var fut_lhs  = Future.trigger();
				var fut_rhs  = Future.trigger();

				var fut_done = fut_lhs.asFuture().merge(fut_rhs.asFuture(),
					(l:Outcome<Oi,Defect<E>>,r:Outcome<Oii,Defect<E>>) -> switch([l,r]){
						case [Failure(l),Failure(r)] : __.failure(l.concat(r));
						case [Failure(e),_] 				 : __.failure(e);
						case [_,Failure(e)] 				 : __.failure(e);
						case [Success(l),Success(r)] : __.success(__.couple(l,r));
					}
				);
				
				var inner_lhs = cont.inner(
					(outcome:Outcome<Oi,Defect<E>>) -> {
						fut_lhs.trigger(outcome);
					}
				);
				var inner_rhs = cont.inner(
					(outcome:Outcome<Oii,Defect<E>>) -> {
						fut_rhs.trigger(outcome);
					}
				);

				var lhr = lhs.defer(i.fst(),inner_lhs);
				var rhr = rhs.defer(i.snd(),inner_rhs);

				return lhr.par(rhr);
		}
	}
	override public function get_convention():Convention{
		return lhs.convention || rhs.convention;
	}
}