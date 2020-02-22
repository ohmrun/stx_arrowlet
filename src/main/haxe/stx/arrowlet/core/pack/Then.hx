package stx.arrowlet.core.pack;

@:forward @:callable abstract Then<A,B,C>(Arrowlet<A,C>) from Arrowlet<A,C> to Arrowlet<A,C>{
	public function  new(fst:Arrowlet<A,B>,snd:Arrowlet<B,C>){
		this = method(fst,snd);
	}
	static function  method<A,B,C>(fst:Arrowlet<A,B>,snd:Arrowlet<B,C>):Arrowlet<A,C>{
		__.that().exists().crunch(fst);
		__.that().exists().crunch(snd);
		return __.arw().cont()((a:A,cont:Continue<C>) -> 
			fst.prepare(a,
				(b:B,auto0:Automation) ->
					snd.prepare(b,(c:C,auto1:Automation) -> cont(c,auto0.concat(auto1)))
			)
		);
	}
}
