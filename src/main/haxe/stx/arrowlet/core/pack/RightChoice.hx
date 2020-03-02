package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.RightChoice in RightChoiceT;

@:forward @:callable abstract RightChoice<B,C,D>(RightChoiceT<B,C,D>) from RightChoiceT<B,C,D> to RightChoiceT<B,C,D>{
	public function  new(arw){
		this = __.arw().cont()(method.bind(arw));
	}
	static private function  method<B,C,D>(arw:Arrowlet<B,C>,i:Either<D,B>,cont:Sink<Either<D,C>>){
		return switch (i) {
			case Right(v) 	:
				new Apply().then(Right).prepare(tuple2(arw,v),cont);
			case Left(v) :
				cont(Left(v),Automation.unit());
		}
	}
}
