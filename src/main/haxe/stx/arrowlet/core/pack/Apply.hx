package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.Apply in ApplyT;

@:forward @:callable abstract Apply<I,O>(ApplyT<I,O>) from ApplyT<I,O> to ApplyT<I,O>{
	public function  new(){
    this = (
      (v:Tuple2<Arrowlet<I,O>,I>,cont) -> v.fst().prepare(v.snd(),cont)
    ).broker(
      (F) -> __.arw().cont
    );    
  }
  public function toArrowlet():Arrowlet<Tuple2<Arrowlet<I,O>,I>,O>{
    return this;
  }
}
