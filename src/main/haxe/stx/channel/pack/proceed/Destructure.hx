package stx.channel.pack.proceed;

class Destructure extends Clazz{
  public function forward<O,E>(self:Proceed<O,E>):IO<O,E>{
    return IO.fromIOT(
      (auto:Automation, next:Outcome<O,E>->Void)-> auto.snoc(self.toArw().prepare(Noise,next))
    );
  }  
  public function postfix<I,O,Z,E>(self:Proceed<O,E>,fn:O->Z):Proceed<Z,E>{
    return self.then(
      Arrowlet.fromFun1R(
        (oc:Outcome<O,E>) -> oc.map(fn)
      )
    );
  }
  public function errata<O,E,EE>(self:Proceed<O,E>,fn):Proceed<O,EE>{
    return self.then(
      Arrowlet.fromFun1R(
        (oc:Outcome<O,E>) -> oc.errata(fn)
      )
    );
  }
}