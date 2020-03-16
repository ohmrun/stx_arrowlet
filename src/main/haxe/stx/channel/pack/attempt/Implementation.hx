package stx.channel.pack.attempt;

class Implementation{
  static inline function _() return Attempt._()._;

  static public function resolve<I,O,Oi,E>(self:Attempt<I,O,E>, next:Resolve<O,Oi,E>):Arrowlet<I,Oi>                return _().resolve(next,self);
  static public function process<I,O,Oi,E>(self:Attempt<I,O,E>, next:Arrowlet<O,Oi>):Attempt<I,Oi,E>                return _().process(next,self);

  static public function errata<I,O,E,EE>(self:Attempt<I,O,E>,fn:TypedError<E>->TypedError<EE>):Attempt<I,O,EE>     return _().errata(fn,self);

  static public function forward<I,O,E>(self:Arrowlet<I,Outcome<O,E>>,i:I):IO<O,E>                                  return _().forward(i,self);

  
  static public function attempt<I,O,Oi,E>(self:Attempt<I,O,E>,next:Arrowlet<O,Outcome<Oi,E>>):Attempt<I,Oi,E>      return _().attempt(next,self);





  static public function toChannel<I,O,E>(self:Attempt<I,O,E>):Channel<I,O,E>                                       return _().toChannel(self);
}