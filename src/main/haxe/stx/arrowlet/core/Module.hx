package stx.arrowlet.core;

@:allow(stx.arrowlet) class Module{
  private function new(){}
  public function unit<I>():Arrowlet<I,I> return Arrowlets.unit();

  public function lift<I,O>(fn:stx.arrowlet.core.head.data.Arrowlet<I,O>):Arrowlet<I,O>{
    return new Arrowlet(fn);
  }
  public function fn<I,O>(fn:I->O):Arrowlet<I,O>{
    return new FunctionArrowlet(fn);
  }
  public function fn2<PI,PII,R>(fn:PI->PII->R):Arrowlet<Tuple2<PI,PII>,R>{
    return new FunctionArrowlet(__.into2(fn));
  }
  public function cb<I,O>(fn:I->(O->Void)->Void):Arrowlet<I,O>{
    return new CallbackArrowlet(fn);
  }
  public function cont<I,O>(fn:I->Sink<O>->Automation):Arrowlet<I,O>{
    return Arrowlets.fromStrandAutomation(fn);
  }
  public function receive<I,O>(f:I->Receiver<O>):Arrowlet<I,O>{
    return new ReceiverArrowlet(f);
  }
  public function recall<I,O>(fn:I -> Reactor<O>):Arrowlet<I,O>{
    return new ReactArrowlet(
      Recall.anon(
        (i,cont) -> fn(i).upply(cont)
      )
    );
  }
  public function uio<I,O,E>(fn:I->UIO<O>):Arrowlet<I,O>{
    return Arrowlet.lift(Recall.anon(
      (i:I,cont:Sink<O>) -> fn(i).duoply(Automation.unit(),cont)
    ));
  }
  public function secrete<I,O>(o:O):Arrowlet<I,O>{
    return fn((_:I)->o);
  }
  public function apply<I,O>():Apply<I,O>{
    return new Apply();
  } 
}