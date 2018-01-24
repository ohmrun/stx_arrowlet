package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.LeftChoice in LeftChoiceT;

@:forward @:callable abstract LeftChoice<B,C,D>(LeftChoiceT<B,C,D>) from LeftChoiceT<B,C,D> to LeftChoiceT<B,C,D>{
	public function new(arw:Arrowlet<B,C>){
		this = Lift.fromSink(
			function(v:Either<B,D>,cont:Sink<Either<C,D>>){
				switch (v) {
					case Left(v) 	:
						new Apply().then(Left)(tuple2(arw,v),cont);
					case Right(v) :
						cont(Right(v));
				}
			}
		);
	}
}
