package stx.arrowlet.core.lift;

class LiftFun1ProceedToAttempt{
  static public function toAttempt<I,O,E>(fn:I->Proceed<O,E>):Attempt<I,O,E>{
    return Attempt.fromFun1Proceed(fn);
  }
}