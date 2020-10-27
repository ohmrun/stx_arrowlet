package stx.arw.arrowlet.term;

class Then<I,Oi,Oii,E> extends ArrowletBase<I,Oii,E>{
	private var lhs : ArrowletDef<I,Oi,E>;
	private var rhs : ArrowletDef<Oi,Oii,E>;

  public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override public function applyII(i:I,cont:Terminal<Oii,E>):Work{
		return new FlatMap(
			lhs,
			(oI) -> {
				return Arrowlet.lift(
					Arrowlet.Anon((_:I,cont:Terminal<Oii,E>) -> rhs.applyII(oI,cont))
				);
			}
		).applyII(i,cont);
	}
}