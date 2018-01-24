package stx.arrowlet.core.pack;

@:forward @:callable abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(fn:I->O){
    this = Lift.fromSink(
      (i:I,cont:Sink<O>) -> cont(fn(i))
    );
  }
}
