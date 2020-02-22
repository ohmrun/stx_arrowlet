package stx.arrowlet.core.head;

class Arrowlets{
  static public var _(default,null) = new stx.arrowlet.core.body.Arrowlets();

  @:noUsing static public function unit<I>():Arrowlet<I,I> return new Unit();

  @:noUsing static public function lift<I,O>(fn:stx.arrowlet.core.head.data.Arrowlet<I,O>):Arrowlet<I,O>{
    return new Arrowlet(fn);
  }
  @:noUsing static public function fromFunction<I,O>(f:I->O):Arrowlet<I,O>{
    return new FunctionArrowlet(f);
  }
  @:noUsing static public function fromFunction2<PI,PII,R>(f):Arrowlet<Tuple2<PI,PII>,R>{
    return new FunctionArrowlet(__.into2(f));
  }
  @:noUsing static public function fromCallbackSink<I,O>(f:I->(O->Void)->Void):Arrowlet<I,O>{
    return new CallbackArrowlet(f);
  }
  @:noUsing static public function fromContinueAutomation<I,O>(f):Arrowlet<I,O>{
    return new Arrowlet((__:Wildcard,cont:Continue<O>,i:I) ->{
      return f(i,cont);
    });
  }
  @:noUsing static public function fromReceiverArrowlet<I,O>(f):Arrowlet<I,O>{
    return new ReceiverArrowlet(f);
  }
  @doc("Pinches the input stage of an Arrowlet. `<I,I>` as `<I>`")
  @:noUsing static public function fromPair<I,O1,O2>(a:Arrowlet<Tuple2<I,I>,Tuple2<O1,O2>>):Arrowlet<I,Tuple2<O1,O2>>{
    return Arrowlets._.fan(Arrowlet.unit()).then(a);
  }
  // @:noUsing public function toState<S,A>(a:Arrowlet<S,Tuple2<A,S>>):State<S,A>{
  //   return new State(a);
  // }
}