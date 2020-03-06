package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.Both in BothT;

@:forward @:callable abstract Both<A,B,C,D>(BothT<A,B,C,D>) from BothT<A,B,C,D> to BothT<A,B,C,D>{
  public function new(fst:Arrowlet<A,B>,snd:Arrowlet<C,D>){
		this = __.arw().cont(method.bind(fst,snd));
	}
	static function  method<A,B,C,D>(fst:Arrowlet<A,B>,snd:Arrowlet<C,D>,tp:Tuple2<A,C>,cont:Sink<Tuple2<B,D>>):Automation{
		return Automation.inj.interim(
			(next:Automation->Void) -> {
				var cancelled 	 	= false;	

				var a 						= None;
				var b 						= None;
		
				
				function ready():Bool{
					return (a != None) && (b != None);
				}
				function go(){
					return switch([ready(),cancelled,a,b]){
						case[true,false,Some(l),Some(r)] 	: 
							next(cont(tuple2(l,r),Automation.unit()));
						default 													: 
					}
				}
				var lhs = Action.lift(fst.deliver(
					(x) -> {
						a = Some(x);
					}
				).fulfill(tp.fst()));
					
				
				var rhs = Action.lift(snd.deliver(
					(x) -> {
						b = Some(x);
					}
				).fulfill(tp.snd()));
				
				var instigator	= Task.inj.pursue(go);
				var automation 	= lhs.forward().concat(rhs.forward()).cons(instigator);
				return automation;
			}
		);
	}
}
