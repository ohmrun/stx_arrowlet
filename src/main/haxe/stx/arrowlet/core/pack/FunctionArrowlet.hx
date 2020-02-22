package stx.arrowlet.core.pack;

@:forward @:callable abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function  new(fn:I->O){
    this = Arrowlets.lift(method.bind(fn));
  }
  static private function  method<I,O>(fn:I->O,__:Wildcard,cont:Continue<O>,i:I):Automation{
    return cont(fn(i),Automation.__.unit());
  }
}