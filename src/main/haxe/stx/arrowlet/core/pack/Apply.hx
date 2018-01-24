package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.Apply in ApplyA;

@:forward @:callable abstract Apply<I,O>(ApplyA<I,O>) from ApplyA<I,O> to ApplyA<I,O>{
	public function new(){
    this = Lift.fromSink(
      function(v:Tuple2<Arrowlet<I,O>,I>,cont:Sink<O>){
        v.fst()(v.snd(),cont);
      }
    );
	}
}
