package stx.async.arrowlet.body;

import stx.data.*;
import tink.core.Callback;

@:forward @:callable abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(fn:I->O){
    this = Lift.fromSink(function(v:I,cont:Sink<O>){
      cont(fn(v));
      return function(){};
    });
  }
}
