package stx.arrowlet.core.pack.arrowlet.term;

class Then<I,Oi,Oii,E> extends ArrowletApi<I,Oii,E>{
	private var lhs : ArrowletDef<I,Oi,E>;
	private var rhs : ArrowletDef<Oi,Oii,E>;

  public function new(lhs,rhs){
		super();
		this.lhs = lhs;
		this.rhs = rhs;
	}
	override private function doApplyII(i:I,cont:Terminal<Oii,E>):Work{
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