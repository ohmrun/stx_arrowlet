package stx.channel.head;

import stx.channel.head.data.Proceed in ProceedT;

class Proceeds{
  static public var _(default,null) = new stx.channel.body.Proceeds();

  @:noUsing static public function lift<T,E>(arw:ProceedT<T,E>):Proceed<T,E> return new Proceed(arw);

  @:noUsing static public function pure<T,E>(v:T):Proceed<T,E>{
    return lift(((_:Noise) -> Val(v))
    .broker(
      F -> __.arw().fn()
    ));
  }
  
  @:noUsing static public function fromThunkT<T,E>(v:Void->T):Proceed<T,E>{
    return lift(((_:Noise) -> Val(v()))
    .broker(
      F -> __.arw().fn()
    ));
  }
  @:noUsing static public function fromIO<T,E>(io:IO<T,E>):Proceed<T,E>{
    return lift(__.arw().cont()(
      (_:Noise,cont) -> Automations.later(
        Waiter.lift(io.apply((Automation.unit()))).fold(
          (v) -> cont(v,Automation.unit()),
          (e) -> Automations.error(__.fault().of(HaltedAt(e))),//
          ()  -> Automation.unit()
        )
      )
    ).postfix(Val));
  }
}