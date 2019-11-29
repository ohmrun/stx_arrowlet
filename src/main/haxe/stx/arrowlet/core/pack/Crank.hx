package stx.arrowlet.core.pack;

import stx.arrowlet.core.body.Cranks;
import stx.arrowlet.core.head.Data.Crank in CrankT;

@:forward @:callable abstract Crank<I,O,E>(CrankT<I,O,E>) from CrankT<I,O,E> to CrankT<I,O,E>{
  public function new(self){
    this = self;
  }
  static public function unit<I,E>():Crank<I,I,E>{
    return function(chk:Chunk<I,E>,cont){
      cont(chk);
      return null;
    }
  }
  public function imply(v:I):Vouch<O,E>{
    return (Cranks.imply(this,v):Vouch<O,E>);
  }
  // public function apply(v:Chunk<I>):Vouch<I>{
  //   return (Cranks.apply(this,v):Vouch<O>);
  // }
}