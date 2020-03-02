package stx.arrowlet.core.pack;

@:forward @:callable abstract FunctionArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function  new(fn:I->O){
    this = Arrowlet.lift(Recall.anon(method.bind(fn)));
  }
  static private function  method<I,O>(fn:I->O,i:I,cont:O->Void):Automation{
    cont(fn(i));
    return Automation.unit();
  }
}