package stx.channel.pack;

import haxe.rtti.CType.Enumdef;


@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:using(stx.channel.pack.Attempt.AttemptLift)
@:forward abstract Attempt<I,O,E>(AttemptDef<I,O,E>) from AttemptDef<I,O,E> to AttemptDef<I,O,E>{
  static public var _(default,never) = AttemptLift;
  
  public function new(self) this = self;
  

  static public function lift<I,O,E>(self:AttemptDef<I,O,E>) return new Attempt(self);
  static public function unto<I,O,E>(self:Arrowlet<I,Res<O,E>>) return new Attempt(self.asRecallDef());

  static public function unit<I,E>():Attempt<I,I,E>{
    return unto(
      Arrowlet.fromRecallFun(
        (i:I,cont:Sink<Res<I,E>>) -> {
          cont(__.success(i));
        }
      )
    );
  }
  static public function pure<I,O,E>(v:Res<O,E>):Attempt<I,O,E>{
    return unto(Arrowlet.pure(v));
  }
  static public function fromIOConstructor<I,O,E>(fn:I->IO<O,E>){
    return unto(
      Arrowlet.fromRecallFun(
        (i,cont) -> fn(i).applyII(Automation.unit(),cont)
      )
    );  
  }
  static public function fromFun1Res<PI,O,E>(fn:PI->Res<O,E>){
    return unto(Arrowlet.fromFun1R(fn));
  }
  static public function fromFun1R<I,O>(fn:I->O):Attempt<I,O,Dynamic>{
    return unto(Arrowlet.fromFun1R(fn).postfix(__.success));
  }
  static public function fromFun1IO<I,O,E>(fn:I->IO<O,E>):Attempt<I,O,E>{
    return unto(Arrowlet.fromRecallFun(
      (i,cont) -> fn(i).applyII(Automation.unit(),cont)
    ));
  }
  static public function fromFun1UIO<I,O>(fn:I->UIO<O>):Attempt<I,O,Dynamic>{
    return unto(Arrowlet.fromRecallFun(
      (i,cont) -> fn(i).applyII(Automation.unit(),
        (o:O) -> cont(__.success(o))
      )
    ));
  }

  @:to public function toArw():Arrowlet<I,Res<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<I,Res<O,E>>):Attempt<I,O,E>{
    return lift(self.asRecallDef());
  }
}
class AttemptLift{
  static private function lift<I,O,E>(self:AttemptDef<I,O,E>)          return new Attempt(self);
  static private function unto<I,O,E>(self:Arrowlet<I,Res<O,E>>)       return new Attempt(self.asRecallDef());

  static public function forward<I,O,E>(self:Arrowlet<I,Res<O,E>>,i:I):IO<O,E>{
    return IO.fromIODef(
        (auto:Automation, next:Res<O,E>->Void)-> auto.snoc(self.prepare(i,next))
    );
  }
  static public function resolve<I,O,Oi,E>(self:Attempt<I,O,E>,next:Resolve<O,Oi,E>):Arrowlet<I,Oi>{
    return self.then(next);
  }
  static public function process<I,O,Oi,E>(self:Attempt<I,O,E>,next:Arrowlet<O,Oi>):Attempt<I,Oi,E>{
    return self.then(Channel.fromArrowlet(next));
  }
  static public function errata<I,O,E,EE>(self:Attempt<I,O,E>,fn:Err<E>->Err<EE>):Attempt<I,O,EE>{
    return self.postfix((oc) -> oc.errata(fn));
  }
  static public function attempt<I,O,Oi,E>(self:Attempt<I,O,E>,next:Arrowlet<O,Res<Oi,E>>):Attempt<I,Oi,E>{
    return lift(self.then(unto(next).toChannel()));
  }

  static public function toChannel<I,O,E>(self:Attempt<I,O,E>):Channel<I,O,E>{
    return Channel.fromAttempt(Arrowlet.lift(self.asRecallDef()));
  }
}