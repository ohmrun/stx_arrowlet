package stx.arrowlet.core.pack;

import stx.assert.body.eq.term.Deferred;

import stx.run.head.data.Receiver in ReceiverT;

abstract ReceiverArrowlet<I,O>(Arrowlet<I,O>) from Arrowlet<I,O> to Arrowlet<I,O>{
  public function  new(fn:I->ReceiverT<O>){
    this = __.arw().cont()(method.bind(fn));
  }
  static private function method<I,O>(fn:I->ReceiverT<O>,i:I,cont:Continue<O>){
    return Automations.later(
      Receiver.lift(fn(i)).map(
        (o) -> cont(o,__)
      )
    );
  }
}