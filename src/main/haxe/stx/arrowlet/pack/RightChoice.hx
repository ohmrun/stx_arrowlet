package stx.arrowlet.pack;

import stx.arrowlet.head.Data.RightChoice in RightChoiceT;

@:forward @:callable abstract RightChoice<B,C,D>(RightChoiceT<B,C,D>) from RightChoiceT<B,C,D> to RightChoiceT<B,C,D>{
	public function new(arw){
		this = Lift.fromSink(function(i:Either<D,B>,cont:Sink<Either<D,C>>){
			switch (i) {
				case Right(v) 	:
					new Apply().then(Right)(tuple2(arw,v),cont);
				case Left(v) :
					cont(Left(v));
			}
		});
	}
}
