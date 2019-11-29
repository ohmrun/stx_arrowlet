package stx.arrowlet.core.pack;

private enum Construction<I,O>{
  VoidContinuationConstructor(fn:I -> Sink<O> -> Void);
  Function1(fn:I->O);
  //Thunk(fn:Void->O); No way to unify / backpropagate
}
abstract Construct<I,O>(Construction<I,O>) from Construction<I,O>{
  public function new(self:Construction<I,O>){
    this = self;
  }
  public function reply():Arrowlet<I,O>{
    return switch(this){
      case VoidContinuationConstructor(fn)       : (i,cont) -> { fn(i,cont); return () -> {}; };
      case Function1(fn)                         : (i,cont) -> { cont(fn(i)); return () -> {}; };
    }
  }
  @:from static public function fromVoidVoidContinuationConstructor<O>(fn:Void->Sink<O>->Void):Construct<Void,O>{
    return VoidContinuationConstructor(fn);
  }
  @:from static public function fromFunction1<I,O>(fn:I->O):Construct<I,O>{
    return Function1(fn);
  }
}