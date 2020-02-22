package stx.arrowlet.core.pack;

@:forward @:callable abstract Amb<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(l:Arrowlet<I,O>,r:Arrowlet<I,O>){
		this = null;
	}
}