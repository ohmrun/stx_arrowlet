package stx.arrowlet.core.pack.arrowlet.term;

typedef ApplyDef<I,O,E>                       = ArrowletDef<Couple<Arrowlet<I,O,E>,I>,O,E>;

@:allow(stx.arrowlet.core.pack)
@:forward abstract Apply<I,O,E>(ApplyDef<I,O,E>) from ApplyDef<I,O,E> to ApplyDef<I,O,E>{
  static public inline function _() return Constructor.ZERO;

  @:deprecated
  static public inline function inj() return Constructor.ZERO;
	private function new(){
    this = new ApplyImplementation();
  }
  static public function unit<I,O>(){
    return _().unit();
  }
}
private class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public function unit<I,O,E>():Apply<I,O,E>{
    return new Apply();
  }
}
private class ApplyImplementation<I,O,E> extends ArrowletBase<Couple<Arrowlet<I,O,E>,I>,O,E>{
  override private function doApplyII(i:Couple<Arrowlet<I,O,E>,I>,cont:Terminal<O,E>):Work{
    return i.decouple(
      (arw:Arrowlet<I,O,E>,i:I) -> arw.prepare(i,cont)
    );
  }
}