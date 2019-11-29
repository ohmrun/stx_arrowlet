package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.RightChoice in RightChoiceT;

@:forward @:callable abstract RightChoice<B,C,D>(RightChoiceT<B,C,D>) from RightChoiceT<B,C,D> to RightChoiceT<B,C,D>{
	public function new(arw){
		this = function(i:Either<D,B>,cont:Sink<Either<D,C>>){
			switch (i) {
				case Right(v) 	:
					new Apply().then(Right).withInput(tuple2(arw,v),cont);
				case Left(v) :
					cont(Left(v));
			}
			return ()->{}
		};
	}
}
