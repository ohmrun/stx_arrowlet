package stx.arrowlet.core.pack;

@:forward @:callable abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function new(fn:I->O){
    this = new Arrowlet(function (_:Wildcard,cont:Sink<O>,i:I):Block{
      cont(fn(i));
      return function(){};
    });
  }
}
