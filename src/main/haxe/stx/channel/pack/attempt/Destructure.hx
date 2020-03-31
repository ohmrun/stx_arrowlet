package stx.channel.pack.attempt;

class Destructure extends Clazz{
  static private function lift<I,O,E>(self:AttemptDef<I,O,E>)          return new Attempt(self);
  static private function unto<I,O,E>(self:Arrowlet<I,Res<O,E>>)       return new Attempt(self.asRecallDef());

  static public function forward<I,O,E>(i:I,self:Arrowlet<I,Res<O,E>>):IO<O,E>{
    return IO.fromIODef(
        (auto:Automation, next:Res<O,E>->Void)-> auto.snoc(self.prepare(i,next))
    );
  }
  static public function resolve<I,O,Oi,E>(next:Resolve<O,Oi,E>,self:Attempt<I,O,E>):Arrowlet<I,Oi>{
    return self.then(next);
  }
  static public function process<I,O,Oi,E>(next:Arrowlet<O,Oi>,self:Attempt<I,O,E>):Attempt<I,Oi,E>{
    return self.then(Channel.fromArrowlet(next));
  }
  static public function errata<I,O,E,EE>(fn:Err<E>->Err<EE>,self:Attempt<I,O,E>):Attempt<I,O,EE>{
    return self.postfix((oc) -> oc.errata(fn));
  }
  static public function attempt<I,O,Oi,E>(next:Arrowlet<O,Res<Oi,E>>,self:Attempt<I,O,E>):Attempt<I,Oi,E>{
    return lift(self.then(unto(next).toChannel()));
  }

  static public function toChannel<I,O,E>(self:Attempt<I,O,E>):Channel<I,O,E>{
    return Channel.fromAttempt(Arrowlet.lift(self.asRecallDef()));
  }
}