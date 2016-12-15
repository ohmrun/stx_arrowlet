package stx.async.arrowlet.body;


import stx.async.arrowlet.head.data.LeftChoice in TLeftChoice;


@:forward @:callable abstract LeftChoice<B,C,D>(TLeftChoice<B,C,D>) from TLeftChoice<B,C,D> to TLeftChoice<B,C,D>{
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
