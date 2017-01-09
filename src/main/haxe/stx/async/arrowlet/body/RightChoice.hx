package stx.async.arrowlet.body;

import stx.async.arrowlet.head.data.RightChoice in TRightChoice;

@:forward @:callable abstract RightChoice<B,C,D>(TRightChoice<B,C,D>) from TRightChoice<B,C,D> to TRightChoice<B,C,D>{
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
