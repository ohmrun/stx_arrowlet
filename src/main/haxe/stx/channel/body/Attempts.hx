package stx.channel.body;

class Attempts extends Clazz{
  // public function  chunk<I,O,E>(fn:I->Outcome<O,E>):Attempt<I,O,E>>{
  //   return fn.broker(
  //     _ -> __.arw().fn().then(
  //       __.channel().attempt()
  //     )
  //   );
  // }
  @:noUsing public function forward<I,O,E>(arw:Arrowlet<I,Outcome<O,E>>,i:I):IO<O,E>{
    return IO.inj.fromIOT(
        (auto:Automation) -> (next:Outcome<O,E>->Void)-> auto.concat(arw.prepare(i,Sink.unit().command(next)))
    );
  }
}