package stx.arrowlet.core.pack;

import stx.run.pack.recall.term.Base;

@:allow(stx.arrowlet.core.pack)
@:forward abstract Apply<I,O>(ApplyDef<I,O>) from ApplyDef<I,O> to ApplyDef<I,O>{
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
  public function unit<I,O>():Apply<I,O>{
    return new Apply();
  }
}
private class ApplyImplementation<I,O> extends Base<Couple<Arrowlet<I,O>,I>,O,Automation>{
  override public function applyII(i:Couple<Arrowlet<I,O>,I>,cont:Sink<O>):Automation{
    return i.fst().prepare(i.snd(),cont);
  }
}