package stx.async.arrowlet.body;

import stx.async.arrowlet.head.data.Only in OnlyT;

@:callable abstract Only<I,O>(OnlyT<I,O>) from OnlyT<I,O> to OnlyT<I,O>{
  public function new(arw:Arrowlet<I,O>){
    this = Lift.fromSink(function(v:Option<I>,cont:Sink<Option<O>>){
      switch (v) {
        case Some(v) : arw.then(Some)(v,cont);
        case None    : cont(None);
      }
    });
  }
}
