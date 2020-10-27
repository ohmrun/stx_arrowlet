package stx.arw.arrowlet.term;

typedef ApplierDef<I,O,E>                       = ArrowletDef<Couple<Arrowlet<I,O,E>,I>,O,E>;

@:allow(stx.arw)
@:forward abstract Applier<I,O,E>(ApplierDef<I,O,E>) from ApplierDef<I,O,E> to ApplierDef<I,O,E>{
  static public inline function _() return Constructor.ZERO;

  @:deprecated
  static public inline function inj() return Constructor.ZERO;
	private function new(){
    this = new ApplierImplementation();
  }
  static public function unit<I,O>(){
    return _().unit();
  }
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public function unit<I,O,E>():Applier<I,O,E>{
    return new Applier();
  }
}
private class ApplierImplementation<I,O,E> extends ArrowletBase<Couple<Arrowlet<I,O,E>,I>,O,E>{
  override public function applyII(i:Couple<Arrowlet<I,O,E>,I>,cont:Terminal<O,E>):Work{
    return i.decouple(
      (arw:Arrowlet<I,O,E>,i:I) -> arw.prepare(i,cont)
    );
  }
}