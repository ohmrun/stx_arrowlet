package stx.channel.body;

class Attempts extends Clazz{
  // public function  chunk<I,O,E>(fn:I->Chunk<O,E>):Attempt<I,O,E>>{
  //   return fn.broker(
  //     _ -> __.arw().fn().then(
  //       __.channel().attempt()
  //     )
  //   );
  // }
  @:noUsing public function forward<I,O,E>(arw:Arrowlet<I,Chunk<O,E>>,i:I):IO<O,E>{
    return IOs.fromIOT(
        (auto:Automation) -> (next:Chunk<O,E>->Void)-> auto.concat(arw.prepare(i,Continue.unit().command(next)))
    );
  }
}