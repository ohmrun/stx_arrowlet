package stx.arrowlet.core.pack.arrowlet;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function lift<I,O>(self:ArrowletDef<I,O>):Arrowlet<I,O>              return new Arrowlet(self);
  
}