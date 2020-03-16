package stx.channel.pack.attempt;

class Destructure extends Clazz{
  private function lift<I,O,E>(self:AttemptDef<I,O,E>)          return new Attempt(self);
  private function unto<I,O,E>(self:Arrowlet<I,Outcome<O,E>>)   return new Attempt(self.asRecallDef());

  public function forward<I,O,E>(i:I,self:Arrowlet<I,Outcome<O,E>>):IO<O,E>{
    return IO.fromIOT(
        (auto:Automation, next:Outcome<O,E>->Void)-> auto.snoc(self.prepare(i,next))
    );
  }
  public function resolve<I,O,Oi,E>(next:Resolve<O,Oi,E>,self:Attempt<I,O,E>):Arrowlet<I,Oi>{
    return self.then(next);
  }
  public function process<I,O,Oi,E>(next:Arrowlet<O,Oi>,self:Attempt<I,O,E>):Attempt<I,Oi,E>{
    return self.then(Channel.fromArrowlet(next));
  }
  public function errata<I,O,E,EE>(fn:TypedError<E>->TypedError<EE>,self:Attempt<I,O,E>):Attempt<I,O,EE>{
    return self.postfix((oc) -> oc.errata(fn));
  }
  public function attempt<I,O,Oi,E>(next:Arrowlet<O,Outcome<Oi,E>>,self:Attempt<I,O,E>):Attempt<I,Oi,E>{
    return lift(self.then(unto(next).toChannel()));
  }

  public function toChannel<I,O,E>(self:Attempt<I,O,E>):Channel<I,O,E>{
    return Channel.fromAttempt(Arrowlet.lift(self.asRecallDef()));
  }
}