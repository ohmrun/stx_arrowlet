package stx.arrowlet.core.pack;

import stx.assert.body.eq.term.Deferred;

abstract ReceiverArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function  new(fn:I->ReceiverDef<O>){
    this = __.arw().cont()(method.bind(fn));
  }
  static public function lift<I,O>(fn:I->ReceiverDef<O>){
    return new ReceiverArrowlet(fn);
  }
  static private function method<I,O>(fn:I->ReceiverDef<O>,i:I,cont:Sink<O>){
    __.log().close().trace('method');
    //var constructor = Receiver.lift.fn().then(Automation.inj.interim);
    //var fn          = fn(i)
    return Automation.inj.interim(
      Receiver.lift(fn(i)).map(
        (o) -> {
          __.log().close().trace('receiver returned: $o');
          return cont(o,Automation.unit());
        }
      )
    );
  }
}