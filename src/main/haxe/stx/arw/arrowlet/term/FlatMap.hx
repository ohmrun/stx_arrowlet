package stx.arw.arrowlet.term;

import stx.log.Facade;

class FlatMap<I,Oi,Oii,E> extends ArrowletCls<I,Oii,E>{
  var self : Arrowlet<I,Oi,E>;
  var func : Oi -> Arrowlet<I,Oii,E>;

	public function new(self,func){
		super();
		this.self = self;
		this.func = func;
	}
	override public function apply(i:I):Oii{
    return throw E_Arw_IncorrectCallingConvention;
  }
  override public function defer(i:I,cont:Terminal<Oii,E>):Work{
		__.log().tag("stx.arw.test")("FlatMap.apply");
	
		var future_response_trigger = Future.trigger();

		var inner 		= cont.inner(
			(res:Outcome<Oi,Defect<E>>) -> {
				future_response_trigger.trigger(
					res.fold(
						(oI:Oi) 			-> {
							return func(oI).prepare(i,cont);
						},
						(e:Defect<E>)	-> {
							return cont.error(e).serve();
						}
					)
				);
			}
		);
		return self.prepare(i,inner).seq(future_response_trigger);
  }
}