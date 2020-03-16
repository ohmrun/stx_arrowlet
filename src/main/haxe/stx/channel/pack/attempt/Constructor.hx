package stx.channel.pack.attempt;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,never) = new Destructure();

  public function lift<I,O,E>(self:AttemptDef<I,O,E>) return new Attempt(self);
  public function unto<I,O,E>(self:Arrowlet<I,Outcome<O,E>>) return new Attempt(self.asRecallDef());

  public function unit<I,E>():Attempt<I,I,E>{
    return unto(
      Arrowlet.fromRecallFun(
        (i:I,cont:Sink<Outcome<I,E>>) -> {
          cont(__.success(i));
          return Automation.unit();
        }
      )
    );
  }
  public function pure<I,O,E>(v:Outcome<O,E>):Attempt<I,O,E>{
    return unto(Arrowlet.pure(v));
  }
  public function fromIOConstructor<I,O,E>(fn:I->IO<O,E>){
    return unto(
      Arrowlet.fromRecallFun(
        (i,cont) -> fn(i).duoply(Automation.unit(),cont)
      )
    );  
  }
  public function fromAttemptFunction<PI,O,E>(fn:PI->Outcome<O,E>){
    return unto(Arrowlet.fromFun1R(fn));
  }
  public function fromFun1R<I,O>(fn:I->O):Attempt<I,O,Dynamic>{
    return unto(Arrowlet.fromFun1R(fn).postfix(__.success));
  }
  public function fromIOFunction<I,O,E>(fn:I->IO<O,E>):Attempt<I,O,E>{
    return unto(Arrowlet.fromRecallFun(
      (i,cont) -> fn(i).duoply(Automation.unit(),cont)
    ));
  }
}