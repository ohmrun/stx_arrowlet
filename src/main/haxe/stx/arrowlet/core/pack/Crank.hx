package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.Data.Crank in CrankT;

@:forward @:callable abstract Crank<I,O>(CrankT<I,O>) from CrankT<I,O> to CrankT<I,O>{
  public function new(self){
    this = self;
  }
  static public function unit<I>():Crank<I,I>{
    return function(chk:Chunk<I>,cont){
      cont(chk);
      return null;
    }
  }
  public function imply(v:I):Vouch<O>{
    return (Cranks.imply(this,v):Vouch<O>);
  }
}