package stx.channel.pack.channel;

import stx.arrowlet.core.pack.arrowlet.Implementation in Arw;

class Implementation{
  static public inline function _() return Channel._()._;

  static public function prepare<I,O,E>(self:Channel<I,O,E>,i:Outcome<I,E>,cont:Sink<Outcome<O,E>>):Automation        return Arw.prepare(Arrowlet.lift(self.asRecallDef()),i,cont);
  static public function then<I,O,Oi,E>(self:Channel<I,O,E>,that:Channel<O,Oi,E>):Channel<I,Oi,E>                     return Arw.then(self,that);

  static public function attempt<I,O,Oi,E>(self:Channel<I,O,E>,that:Attempt<O,Oi,E>):Channel<I,Oi,E>                  return _().attempt(that,self);
  static public function process<I,O,Oi,E>(self:Channel<I,O,E>,that:Arrowlet<O,Oi>):Channel<I,Oi,E>                   return _().process(that,self);

  static public function or<I,O,Ii,E>(that:Channel<Ii,O,E>,self:Channel<I,O,E>):Channel<Either<I,Ii>,O,E>             return _().or(that,self);
  

  static public function reframe<I,O,E>(self:Channel<I,O,E>):Reframe<I,O,E>                                           return _().reframe(self);
  static public function errata<I,O,E,EE>(self:Channel<I,O,E>,fn:TypedError<E>->TypedError<EE>):Channel<I,O,EE>       return _().errata(fn,self);
  static public function forward<I,O,E>(self:Channel<I,O,E>,i:I):IO<O,E>                                              return _().forward(i,self);
}