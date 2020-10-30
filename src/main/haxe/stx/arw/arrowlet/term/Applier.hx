package stx.arw.arrowlet.term;

typedef ApplierDef<I,O,E>                       = ArrowletDef<Couple<Arrowlet<I,O,E>,I>,O,E>;

@:allow(stx.arw)
@:forward abstract Applier<I,O,E>(ApplierDef<I,O,E>) from ApplierDef<I,O,E> to ApplierDef<I,O,E>{
  static public var _(default,never) = ApplierLift;
  
  public function unit<I,O,E>():Applier<I,O,E>{
    return new Applier();
  }
	private function new(){
    this = new ApplierImplementation();
  }
}
class ApplierLift{
  
  
}
private class ApplierImplementation<I,O,E> extends ArrowletCls<Couple<Arrowlet<I,O,E>,I>,O,E>{
  override public function defer(i:Couple<Arrowlet<I,O,E>,I>,cont:Terminal<O,E>):Work{
    return i.decouple(
      (arw:Arrowlet<I,O,E>,i:I) -> arw.prepare(i,cont)
    );
  }
  override public function apply(i:Couple<Arrowlet<I,O,E>,I>):O{
    return i.fst().convention.fold(
      () -> throw E_Arw_IncorrectCallingConvention,
      () -> i.fst().apply(i.snd())
    );
  }
  /**
    Given you don't know the convention of the incoming Arrowlet, it's ASYNC.
  **/
  override public function get_convention(){
    return ASYNC;
  }
}