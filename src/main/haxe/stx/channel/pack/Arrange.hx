package stx.channel.pack;

@:forward abstract Arrange<I,S,O,E>(ArrangeDef<I,S,O,E>) from ArrangeDef<I,S,O,E> to ArrangeDef<I,S,O,E>{
  static public inline function _() return Constructor.ZERO;

  public function new(self) this = self;
  static public function lift<I,S,O,E>(self:ArrangeDef<I,S,O,E>):Arrange<I,S,O,E>         return new Arrange(self);
  static public function pure<I,S,O,E>(o:O)                                               return _().pure(o);

  public function state()                                                                 return _()._.state(this)                            ;

  @:to public function toArw():Arrowlet<Tuple2<I,S>,Outcome<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,S,O,E>(self:Arrowlet<Tuple2<I,S>,Outcome<O,E>>):Arrange<I,S,O,E>{
    return lift(self.asRecallDef());
  }
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  static public function lift<I,S,O,E>(self:ArrangeDef<I,S,O,E>):Arrange<I,S,O,E>                         return new Arrange(self);
  static public function unto<I,S,O,E>(self:Arrowlet<Tuple2<I,S>,Outcome<O,E>>):Arrange<I,S,O,E>          return new Arrange(self.asRecallDef());

  public function pure<I,S,O,E>(o:O):Arrange<I,S,O,E>{
    return unto(Arrowlet.fromFun1R(
      (i:Tuple2<I,S>) ->  __.success(o)
    ));
  }
}
private class Destructure extends Clazz{
  public function state<I,S,O,E>(self:Arrange<I,S,O,E>):Attempt<Tuple2<I,S>,Tuple2<O,S>,E>{
    return Attempt.lift(self.broach().postfix(
      __.into2(
        (tp:Tuple2<I,S>,chk:Outcome<O,E>) -> chk.map(tuple2.bind(_,tp.snd()))
      )
    ));
  }
}