package stx.arw.arrowlet.term;

class FlatMap<I,Oi,Oii,E> extends ArrowletBase<I,Oii,E>{
  var self : Arrowlet<I,Oi,E>;
  var func : Oi -> Arrowlet<I,Oii,E>;

	public function new(self,func){
		super();
		this.self = self;
		this.func = func;
	}
  override private function doApplyII(i:I,cont:Terminal<Oii,E>):Work{
		var defer 									= Future.trigger();
		var future_response_trigger = Future.trigger();

		var inner 		= cont.inner(
			(res:Outcome<Oi,E>) -> {
				future_response_trigger.trigger(
					res.fold(
						(oI:Oi) 			-> {
							return func(oI).prepare(i,cont);
						},
						(e:E)	  			-> {
							return cont.error(e).serve();
						}
					)
				);
			}
		);
		return self.prepare(i,inner).seq(future_response_trigger);
  }
}