package stx.async.arrowlet;

import stx.async.Arrowlet;

import tink.CoreApi;

class Lift{
  public function new(){}
  public function fromFuture<I,O>(fn:I->Future<O>):Arrowlet<I,O>{
    return function(i,cont){
      fn(i).handle(cont);
      return null;
    }
  }
}