package stx.channel.pack;

import haxe.rtti.CType.Enumdef;
import stx.channel.head.data.Attempt in AttemptT;

@:forward abstract Attempt<I,O,E>(AttemptT<I,O,E>) from AttemptT<I,O,E> to AttemptT<I,O,E>{
  public function new(self) this = self;
  static public var inj(default,null) = new Constructor();

  @:noUsing static public function unit<I,E>():Attempt<I,I,E>                     return lift(__.arw().fn(__.success));
  @:noUsing static public function lift<I,O,E>(self:AttemptT<I,O,E>)              return new Attempt(self);
  @:noUsing static public function pure<I,O,E>(v:Outcome<O,E>):Attempt<I,O,E>     return Attempts.pure(v);

  public function resolve<Z>(arw:Resolve<O,Z,E>):Arrowlet<I,Z>{
    return this.then(arw.prj());
  }
  public function toChannel():Channel<I,O,E>{
    return Channels.fromAttempt(this);
  }
  public function prj():AttemptT<I,O,E>{
    return this;
  }
  public function process<R>(arw:Arrowlet<O,R>):Attempt<I,R,E>{
    return lift(
      this.then(Channels.fromArrowlet(arw))
    );
  }
  public function postfix<Z>(fn:O->Z):Attempt<I,Z,E>{
    return lift(
      this.then(Channels.fromArrowlet(fn))
    );
  }
  public function forward(i:I):IO<O,E>{
    return Attempts._.forward(this,i);
  }
  public function errata<EE>(fn:TypedError<E>->TypedError<EE>):Attempt<I,O,EE>{
    return lift(this.postfix(Outcome.inj._.errata.bind(fn)));
  }
  public function attempt<Z>(arw:Arrowlet<O,Outcome<Z,E>>):Attempt<I,Z,E>{
    return lift(this.then(lift(arw).toChannel()));
  }
  public function toArrowlet():Arrowlet<I,Outcome<O,E>>{
    return this;
  }
}
private class Constructor extends Clazz{
  public function fromFunction<I,O>(fn:I->O):Attempt<I,O,Dynamic>{
    return Arrowlet.fromFunction(fn).postfix(__.success);
  }
  public function fromIOFunction<I,O,E>(fn:I->IO<O,E>):Attempt<I,O,E>{
    return Arrowlets.fromReceiverArrowlet(
      (i) -> fn(i)(Automation.unit())
    );
  }
}