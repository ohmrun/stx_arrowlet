package stx.arrowlet.core.pack.arrowlet;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function lift<I,O>(self:ArrowletDef<I,O>):Arrowlet<I,O>              return new Arrowlet(self);
  public inline function unto<T:RecallDef<I,O,Automation>,I,O>(t:T):Arrowlet<I,O>{
    return lift(t.asRecallDef());
  }
  public function unit<I>():Arrowlet<I,I>{
    return lift(new Sync(__.through()).asRecallDef());
  }
  public function pure<I,O>(o:O):Arrowlet<I,O>{
    return unto(new Pure(o));
  }

  public function Apply<I,O>():Arrowlet<Couple<Arrowlet<I,O>,I>,O>{
    return unto(new Apply());
  }
  public function fromRecallFun<I,O>(fun:RecallFun<I,O,Void>):Arrowlet<I,O>{
    return lift(new InputReactor(fun).asRecallDef());
  }
  public function fromFunXR<O>(f:Void->O):Arrowlet<Noise,O>{
    return lift(new Sync((_:Noise)->f()));
  }
  public function fromFun1R<I,O>(f:I->O):Arrowlet<I,O>{
    return lift(new Sync(f));
  }
  public function fromFun2R<PI,PII,R>(f):Arrowlet<Couple<PI,PII>,R>{
    return lift(new Sync(__.decouple(f)));
  }
  public function fromInputReactor<I,O>(f:I->(O->Void)->Void):Arrowlet<I,O>{
    return fromRecallFun(f);
  }
  public function fromInputReceiver<I,O>(f:I->Receiver<O>):Arrowlet<I,O>{
    return lift(new InputReceiver(f).asRecallDef());
  }
}