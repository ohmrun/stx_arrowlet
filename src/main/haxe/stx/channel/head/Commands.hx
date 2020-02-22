package stx.channel.head;

import stx.channel.head.data.Command in CommandT;

class Commands{
  static public function lift<I,E>(arw:CommandT<I,E>):Command<I,E>{
    return new Command(arw);
  }
  static public function fromEIOConstructor<PI,E>(fn:PI->EIO<E>):Command<PI,E>{
    var fn = (i:PI,cont:Continue<Option<TypedError<E>>>) -> 
      Automations.later(
        fn(i)
        .toUIO()(Automation.unit())
        .broker(
          F -> Receiver.lift
        ).map(
          (opt:Option<TypedError<E>>) -> cont(opt,Automations.unit())
        )
      );
    var arw  = lift(__.arw().cont()(fn));
    return arw;
  }
}