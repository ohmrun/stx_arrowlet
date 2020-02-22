package stx.channel.body;


class Proceeds extends Clazz{
  @:noUsing public function forward<I,O,E>(arw:Arrowlet<Noise,Chunk<O,E>>):IO<O,E>{
    return IOs.fromIOT(
        (auto:Automation) -> (next:Chunk<O,E>->Void)-> auto.concat(arw.prepare(Noise,Continue.unit().command(next)))
    );
  }  
  @:noUsing public function postfix<I,O,Z,E>(self:Proceed<O,E>,fn:O->Z):Proceed<Z,E>{
    return self.then(
      Chunks._.map.bind(fn)
    );
  }
  public function errata<O,E,EE>(self:Proceed<O,E>,fn):Proceed<O,EE>{
    return self.then(
      Chunks._.errata.bind(fn)
    );
  }
}