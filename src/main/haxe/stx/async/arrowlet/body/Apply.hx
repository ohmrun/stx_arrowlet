package stx.async.arrowlet.body;

typedef AAIn<I,O> 			= Tuple2<Arrowlet<I,O>,I>;
typedef TApply<I,O> 		= Arrowlet<AAIn<I,O>,O>;

@:forward @:callable abstract Apply<I,O>(Arrowlet<AAIn<I,O>,O>) from Arrowlet<AAIn<I,O>,O> to Arrowlet<AAIn<I,O>,O>{
	public function new(){
    this = Lift.fromSink(
      function(v:Tuple2<Arrowlet<I,O>,I>,cont:Sink<O>){
        v.fst()(v.snd(),cont);
      }
    );
	}
}
