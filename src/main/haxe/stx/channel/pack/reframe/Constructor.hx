package stx.channel.pack.reframe;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  public function pure<I,O,E>(o:O):Reframe<I,O,E>{
    return lift(Channel.unit().postfix(
      (oc:Outcome<I,E>
        ) -> (oc.map(tuple2.bind(o)):Outcome<Tuple2<O,I>,E>)
    ));
  }
}