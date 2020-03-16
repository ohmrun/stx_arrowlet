package stx.channel.pack;

import haxe.rtti.CType.Enumdef;

import stx.channel.pack.attempt.Constructor;

@:using(stx.arrowlet.core.pack.arrowlet.Implementation)
@:using(stx.channel.pack.attempt.Implementation)
@:forward abstract Attempt<I,O,E>(AttemptDef<I,O,E>) from AttemptDef<I,O,E> to AttemptDef<I,O,E>{
  static public inline function _() return Constructor.ZERO;
  
  public function new(self) this = self;
  

  static public function lift<I,O,E>(self:AttemptDef<I,O,E>)                              return new Attempt(self);

  static public function unit<I,E>():Attempt<I,I,E>                                       return _().unit();
  static public function pure<I,O,E>(v:Outcome<O,E>):Attempt<I,O,E>                       return _().pure(v);

  static public function fromIOConstructor<I,R,E>(fn:I->IO<R,E>)                          return _().fromIOConstructor(fn);
  static public function fromAttemptFunction<PI,R,E>(fn:PI->Outcome<R,E>)                 return _().fromAttemptFunction(fn);
  static public function fromFun1R<I,O>(fn:I->O):Attempt<I,O,Dynamic>                     return _().fromFun1R(fn);
  static public function fromIOFunction<I,O,E>(fn:I->IO<O,E>):Attempt<I,O,E>              return _().fromIOFunction(fn);

  @:to public function toArw():Arrowlet<I,Outcome<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<I,Outcome<O,E>>):Attempt<I,O,E>{
    return lift(self.asRecallDef());
  }
}

