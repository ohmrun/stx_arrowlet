package stx.async.arrowlet;

@:callable abstract Future<I,O>(Arrowlet<I,O>) from Arrowlet<I,O>{
  public function new(fn:I->Future<O>){
    
  }
}