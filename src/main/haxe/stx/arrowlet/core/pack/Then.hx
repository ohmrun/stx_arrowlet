package stx.arrowlet.core.pack;

@:forward @:callable abstract Then<A,B,C>(Arrowlet<A,C>) from Arrowlet<A,C> to Arrowlet<A,C>{
	public function new(fst:Arrowlet<A,B>,snd:Arrowlet<B,C>){
		this = function(i:A,cont:Sink<C>):Block{
			var cn0,cn1 = null;
			fst.withInput(
				i,
				(b:B) -> cn1 = snd.withInput(b,cont)
			);
			return function(){
				(cn0:Posit).each(upply);
				(cn1:Posit).each(upply);
			}
		}
	}
}
