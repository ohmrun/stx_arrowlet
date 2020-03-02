package stx.channel.body;


class Proceeds extends Clazz{
  @:noUsing public function forward<I,O,E>(arw:Arrowlet<Noise,Outcome<O,E>>):IO<O,E>{
    return IO.inj.fromIOT(
        (auto:Automation) -> (next:Outcome<O,E>->Void)-> auto.concat(arw.prepare(Noise,Sink.unit().command(next)))
    );
  }  
  @:noUsing public function postfix<I,O,Z,E>(self:Proceed<O,E>,fn:O->Z):Proceed<Z,E>{
    return self.then(
      Outcome.inj._.map.bind(fn)
    );
  }
  public function errata<O,E,EE>(self:Proceed<O,E>,fn):Proceed<O,EE>{
    return self.then(
      Outcome.inj._.errata.bind(fn)
    );
  }
}