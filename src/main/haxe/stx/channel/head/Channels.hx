package stx.channel.head;

import stx.channel.head.data.Channel in ChannelT;

class Channels{
  static public var _(default,null) = new stx.channel.body.Channels();

  @:noUsing static public function lift<A,B,E>(self:Arrowlet<Outcome<A,E>,Outcome<B,E>>):Channel<A,B,E>{
    return new Channel(self);
  }
  @:noUsing static public function unit<I,E>():Channel<I,I,E>{
    return __.arw().fn(
      (chk:Outcome<I,E>) -> chk
    );
  }
  @:noUsing static public function pure<I,O,E>(v:Outcome<O,E>):Channel<I,O,E>{
    return lift(__.arw().fn((chk:Outcome<I,E>) -> v
    ));
  }
  @:noUsing public function fromProcess<I,O,E>(thiz:Arrowlet<I,O>):Channel<I,O,E>{
    return fromArrowlet(thiz);
  }
  @:noUsing static public function fromArrowlet<A,B,E>(arw:Arrowlet<A,B>):Channel<A,B,E>{
    return Outcome.inj._.fold.bind(
      (v) -> arw.postfix(__.success).receive(v),
      (e) -> Receiver.inj.pure(Outcome.lift(__.failure(e)))
    ).broker(
      F -> F.then(__.arw().receive()).then(lift)
    );
  }
  @:noUsing static public function fromAttempt<A,B,E>(arw:Arrowlet<A,Outcome<B,E>>):Channel<A,B,E>{
    return __.arw().receive()(
      Outcome.inj._.fold.bind(
        (v) -> arw.receive(v),
        (e) -> Receiver.inj.pure(Outcome.lift(__.failure(e)))
      )
    );
  }
  @:noUsing static public function fromResolve<A,B,E>(arw:Arrowlet<Outcome<A,E>,B>):Channel<A,B,E>{
    return lift(arw.postfix(__.success));
  }
  @:noUsing static public function fromRecover<A,E>(arw:Arrowlet<TypedError<E>,A>):Channel<A,A,E>{
    return lift(Outcome.inj._.fold.bind(
      (v) -> Receiver.inj.pure(__.success(v)),
      (e) -> arw.postfix(__.success).receive(e)
    ).broker(
      (F) -> __.arw().receive()
    ));
  }
  @:noUsing static public function fromCommand<A,E>(arw:Arrowlet<A,Option<TypedError<E>>>):Channel<A,A,E>{
    return __.arw().cont(
      (ipt:Outcome<A,E>,cont:Strand<Outcome<A,E>>) -> {
        return switch(ipt){
          case Right(v) : 
            arw.postfix(
              (opt:Option<TypedError<E>>) -> opt.fold(
                (e) -> __.failure(e),
                ()  -> __.success(v)
              )
            ).prepare(v,cont);
          case Left(e) : cont(__.failure(e),Automation.inj().unit());
        }
      }
    );
  }
  @:noUsing static public function fromProceed<A,E>(arw:Arrowlet<Noise,Outcome<A,E>>):Channel<Noise,A,E>{
    return __.arw().cont(
      (i,cont) -> Outcome.inj._.fold.bind(
        (v) -> arw,
        (e)   -> __.arw().secrete(__.failure(e))
      )(i).prepare(Noise,cont)
    );
  }
}