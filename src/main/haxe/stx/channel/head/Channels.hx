package stx.channel.head;

import stx.channel.head.data.Channel in ChannelT;

class Channels{
  static public var _(default,null) = new stx.channel.body.Channels();

  @:noUsing static public function lift<A,B,E>(self:Arrowlet<Chunk<A,E>,Chunk<B,E>>):Channel<A,B,E>{
    return new Channel(self);
  }
  @:noUsing static public function unit<I,E>():Channel<I,I,E>{
    return __.arw().fn()(
      (chk:Chunk<I,E>) -> chk
    );
  }
  @:noUsing static public function pure<I,O,E>(v:Chunk<O,E>):Channel<I,O,E>{
    return lift(__.arw().fn()(
      (chk:Chunk<I,E>) -> v
    ));
  }
  @:noUsing public function fromProcess<I,O,E>(thiz:Arrowlet<I,O>):Channel<I,O,E>{
    return fromArrowlet(thiz);
  }
  @:noUsing static public function fromArrowlet<A,B,E>(arw:Arrowlet<A,B>):Channel<A,B,E>{
    return Chunks._.fold.bind(
      (v) -> arw.then(Val).receive(v),
      (e) -> __.of(End(e)).receive(),
      ()  -> __.of(Tap).receive()
    ).broker(
      F -> F.then(__.arw().receive()).then(lift)
    );
  }
  @:noUsing static public function fromAttempt<A,B,E>(arw:Arrowlet<A,Chunk<B,E>>):Channel<A,B,E>{
    return __.arw().receive()(
      Chunks._.fold.bind(
        (v) -> arw.receive(v),
        (e) -> __.of(End(e)).receive(),
        ()  -> __.of(Tap).receive()
      )
    );
  }
  @:noUsing static public function fromResolve<A,B,E>(arw:Arrowlet<Chunk<A,E>,B>):Channel<A,B,E>{
    return lift(arw.postfix(Val));
  }
  @:noUsing static public function fromRecover<A,E>(arw:Arrowlet<TypedError<E>,A>):Channel<A,A,E>{
    return lift(Chunks._.fold.bind(
      (v) -> __.of(Val(v)).receive(),
      (e) -> arw.then(Val).receive(e),
      ()  -> __.of(Tap).receive()
    ).broker(
      (F) -> __.arw().receive()
    ));
  }
  @:noUsing static public function fromCommand<A,E>(arw:Arrowlet<A,Option<TypedError<E>>>):Channel<A,A,E>{
    return __.arw().cont()(
      (ipt:Chunk<A,E>,cont:Continue<Chunk<A,E>>) -> {
        return switch(ipt){
          case Val(v) : 
            arw.postfix(
              (opt:Option<TypedError<E>>) -> opt.fold(
                (e) -> End(e),
                ()  -> Val(v)
              )
            ).prepare(v,cont);
          case End(e) : cont(End(e),Automation.unit());
          case Tap    : cont(Tap,Automation.unit());
        }
      }
    );
  }
  @:noUsing static public function fromProceed<A,E>(arw:Arrowlet<Noise,Chunk<A,E>>):Channel<Noise,A,E>{
    return __.arw().cont()(
      (i,cont) -> Chunks._.fold.bind(
        (v) -> arw,
        (e)   -> __.arw().secrete(End(e)),
        ()    -> __.arw().secrete(Tap)
      )(i).prepare(Noise,cont)
    );
  }
}