package stx.arrowlet.core.pack;

abstract CallbackArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{

  public function  new(cb:I->(O->Void)->Void){
    this = __.arw().cont(method.bind(cb));
  }
  static private function  method<I,O>(cb:I->(O->Void)->Void,i:I,cont:Sink<O>):Automation{
    return Automation.inj().interim(
      Reactor.inj().into((next:Sink<Automation>) -> {
        cb(i,
          (o) -> {
            cont(o);
            next(Automation.unit());
          }
        );
      }
    ));
  }
}