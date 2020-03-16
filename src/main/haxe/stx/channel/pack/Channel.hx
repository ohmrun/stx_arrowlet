package stx.channel.pack;

import stx.channel.pack.channel.Constructor;

@:using(stx.arrowlet.core.pack.arrowlet.Implementation)
@:using(stx.channel.pack.channel.Implementation)
@:forward abstract Channel<I,O,E>(ChannelDef<I,O,E>) from ChannelDef<I,O,E> to ChannelDef<I,O,E>{
  static public inline function _()  return Constructor.ZERO;
  public function new(self) this = self;
  
  static public function lift<I,O,E>(self:ChannelDef<I,O,E>)                                        return new Channel(self);
  static public function unit<I,E>():Channel<I,I,E>                                                 return _().unit();
  static public function pure<I,O,E>(v:Outcome<O,E>):Channel<I,O,E>                                 return _().pure(v);

  static public function fromArrowlet<I,O,E>(self:Arrowlet<I,O>):Channel<I,O,E>                     return _().fromArrowlet(self);
  static public function fromAttempt<I,O,E>(self:Arrowlet<I,Outcome<O,E>>):Channel<I,O,E>           return _().fromAttempt(self);
  static public function fromResolve<I,O,E>(self:Arrowlet<Outcome<I,E>,O>):Channel<I,O,E>           return _().fromResolve(self);
  static public function fromRecover<I,E>(self:Arrowlet<TypedError<E>,I>):Channel<I,I,E>            return _().fromRecover(self);
  static public function fromCommand<I,E>(self:Arrowlet<I,Option<TypedError<E>>>):Channel<I,I,E>    return _().fromCommand(self);
  static public function fromProceed<O,E>(self:Arrowlet<Noise,Outcome<O,E>>):Channel<Noise,O,E>     return _().fromProceed(self);
  
  @:to public function toArw():Arrowlet<Outcome<I,E>,Outcome<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Outcome<I,E>,Outcome<O,E>>):Channel<I,O,E>{
    return lift(self.asRecallDef());
  }
}