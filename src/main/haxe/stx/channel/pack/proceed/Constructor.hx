package stx.channel.pack.proceed;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function lift<O,E>(self:ProceedDef<O,E>):Proceed<O,E> return new Proceed(self);
  public function unto<O,E>(self:Arrowlet<Noise,Res<O,E>>):Proceed<O,E> return new Proceed(self.asRecallDef());

  public function pure<O,E>(v:O):Proceed<O,E>{
    return unto(Arrowlet.fromFun1R((_:Noise) -> __.success(v)));
  }
  public function fromThunkT<O,E>(fn:Void->O):Proceed<O,E>{
    return unto(
      Arrowlet.fromFun1R(
        (_:Noise) -> __.success(fn())
      )
    );
  }
  public function fromIO<O,E>(io:IO<O,E>):Proceed<O,E>{
    return lift(Recall.Anon(
      (_:Noise,cont:Sink<Res<O,E>>) ->  io.applyII(
        Automation.unit(),
        cont
      )
    ));
  }
}