package stx.arrowlet.core;

@:allow(stx.arrowlet) class Module{
  private function new(){}
  public function unit<I>():Arrowlet<I,I> return Arrowlets.unit();

  public function lift<I,O>(fn:stx.arrowlet.core.head.data.Arrowlet<I,O>):Arrowlet<I,O>{
    return new Arrowlet(fn);
  }
  public function fn<I,O>():Unary<Unary<I,O>,Arrowlet<I,O>>{
    return (f:I->O) -> new FunctionArrowlet(f);
  }
  public function fn2<PI,PII,R>():Unary<PI->PII->R,Arrowlet<Tuple2<PI,PII>,R>>{
    return f -> new FunctionArrowlet(__.into2(f));
  }
  public function cb<I,O>():Unary<I->(O->Void)->Void,Arrowlet<I,O>>{
    return f -> new CallbackArrowlet(f);
  }
  public function cont<I,O>():Unary<I->Continue<O>->Automation,Arrowlet<I,O>>{
    return Arrowlets.fromContinueAutomation.fn();
  }
  public function receive<I,O>():Unary<I->Receiver<O>,Arrowlet<I,O>>{
    return f -> new ReceiverArrowlet(f);
  }
  public function uio<I,O,E>(fn:I->UIO<O>):Arrowlet<I,O>{
    return __.arw().receive()(
      fn.fn().then(io -> Receiver.lift(io(Automation.unit())))
   );
  }
  public function secrete<I,O>(o:O):Arrowlet<I,O>{
    return fn()((_:I)->o);
  }
  public function apply<I,O>():Apply<I,O>{
    return new Apply();
  } 
}