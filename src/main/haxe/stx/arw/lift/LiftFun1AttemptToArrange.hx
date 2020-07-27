package stx.arw.lift;

class LiftFun1AttemptToArrange{
  static public function toArrange<I,S,O,E>(fn:I->Attempt<S,O,E>){
    return Arrange.fromFun1Attempt(fn);
  }
}