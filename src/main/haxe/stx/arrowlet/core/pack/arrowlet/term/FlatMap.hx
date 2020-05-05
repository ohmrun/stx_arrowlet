package stx.arrowlet.core.pack.arrowlet.term;

class FlatMap<I,Oi,Oii,E> extends ArrowletApi<I,Oii,E>{
  var self : Arrowlet<I,Oi,E>;
  var func : Oi -> Arrowlet<I,Oii,E>;

	public function new(self,func){
		super();
		this.self = self;
		this.func = func;
	}
  override private function doApplyII(i:I,cont:Terminal<Oii,E>):Response{
		var defer 									= Future.trigger();
		var future_response_trigger = Future.trigger();

		var inner 		= cont.inner(
			(res:Outcome<Oi,E>) -> {
				future_response_trigger.trigger(
					res.fold(
						(oI) -> func(oI).prepare(i,cont),
						(e)	 -> cont.error(e).serve()
					)
				);
			}
		);
		return self.prepare(i,inner).seq(cont.waits(future_response_trigger));
  }
}