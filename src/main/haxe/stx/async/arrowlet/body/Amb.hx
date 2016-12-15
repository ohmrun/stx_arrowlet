package stx.async.arrowlet.body;


using stx.core.Blocks;
import stx.core.Blocks.upply;

abstract Amb<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
	public function new(l:Arrowlet<I,O>,r:Arrowlet<I,O>){
		this = function(v:I,cont:Sink<O>){
			var out 	= None;
			var c0 : Maybe<Block>, c1 : Maybe<Block> = null;
			c0  = l(v,
				function(x){
					if(out == None){
						out = Some(v);
					}
					c1.each(upply);
				}
			);
			c1  = r(v,
				function(x){
					if(out == None){
						out = Some(v);
					}
					c0.each(upply);
				}
			);

			return function(){
				c0.each(upply);
				c1.each(upply);
			}
		};
	}
}
