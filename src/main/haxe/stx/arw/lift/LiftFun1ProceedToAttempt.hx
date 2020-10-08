package stx.arw.lift;

class LiftFun1ProduceToAttempt{
  static public function toAttempt<I,O,E>(fn:I->Produce<O,E>):Attempt<I,O,E>{
    return Attempt.fromFun1Produce(fn);
  }
}