package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.LeftChoice in LeftChoiceT;

@:forward @:callable abstract LeftChoice<B,C,D>(LeftChoiceT<B,C,D>) from LeftChoiceT<B,C,D> to LeftChoiceT<B,C,D>{
	public function  new(arw:Arrowlet<B,C>){
		this = __.arw().cont()(method.bind(arw));
	}
	static private function  method<B,C,D>(arw:Arrowlet<B,C>,v:Either<B,D>,cont:Continue<Either<C,D>>){
		return switch (v) {
			case Left(v) 	: new Apply().then(Left).prepare(tuple2(arw,v),cont);
			case Right(v) : cont(Right(v),Automation.unit());
		}
	}
}
