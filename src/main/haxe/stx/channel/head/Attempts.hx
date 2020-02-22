package stx.channel.head;

import stx.channel.head.data.Attempt in AttemptT;

class Attempts{
  static public var _(default,null) = new stx.channel.body.Attempts();
  @:noUsing static public function lift<I,O,E>(self:AttemptT<I,O,E>) return new Attempt(self);
  @:noUsing static public function pure<I,O,E>(v:Chunk<O,E>):Attempt<I,O,E>{
    return lift(__.arw().fn()(
      (chk:I) -> v
    ));
  }
  @:noUsing static public function fromIOConstructor<I,R,E>(fn:I->IO<R,E>){
    return Attempts.lift(
      Arrowlets.fromReceiverArrowlet(
        fn.fn().then(f -> f(__)).then(Receiver.lift)
      )
    );  
  }  
  @:noUsing static public function  fromAttemptFunction<PI,R,E>(fn:PI->Chunk<R,E>){
    return lift(__.arw().fn()(fn));
  }
}