package stx.arrowlet.core.pack;

private enum Construction<I,O>{
  VoidContinuationConstructor(fn:I -> (O->Void) -> Void);
  Function1(fn:I->O);
  //AutomationConstructor(fn:O->Automation<I,O>);
}
abstract Construct<I,O>(Construction<I,O>) from Construction<I,O>{
  public function new(self:Construction<I,O>){
    this = self;
  }
  @:to public function reply():Arrowlet<I,O>{
    return switch(this){
      case VoidContinuationConstructor(fn): _VoidContinuationConstructor(fn);
      case Function1(fn): Arrowlet.fromFunction(fn);
      //case AutomationConstructor(fn):
    }
  }
  @:from static public function fromVoidVoidContinuationConstructor<O>(fn:Void->(O->Void)->Void):Construct<Void,O>{
    return VoidContinuationConstructor(fn);
  }
  @:from static public function fromFunction1<I,O>(fn:I->O):Construct<I,O>{
    return Function1(fn);
  }
  static function _VoidContinuationConstructor<I,O>(fn:I->(O->Void)->Void):Arrowlet<I,O>{
    return new CallbackArrowlet(fn);
  }
}