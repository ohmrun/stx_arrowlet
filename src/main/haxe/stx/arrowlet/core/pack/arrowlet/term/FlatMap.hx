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
		var receiver 								= cont.defer(defer);
		var future_response_trigger = Future.trigger();

		var innerI 		= cont.inner(
			(res:Res<Oi,E>) -> {
				var response = res.fold(
					(oI) -> 
				);
			}
		);
		return receiver.after(self.prepare(i,inner).seq(future_respose));
  }
}