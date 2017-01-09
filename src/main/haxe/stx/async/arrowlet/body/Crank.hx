package stx.async.arrowlet.body;

import stx.data.Block;

import stx.Maybe;

import stx.Chunk;
import stx.Error;

import stx.Vouch;
import tink.core.Future;
import tink.core.Noise;
import tink.core.Callback;

using stx.Tuple;

using stx.async.arrowlet.body.Crank;

using stx.Chunk;


typedef ArrowletCrank<I,O> = Arrowlet<Chunk<I>,Chunk<O>>;

@:forward @:callable abstract Crank<I,O>(ArrowletCrank<I,O>) from ArrowletCrank<I,O> to ArrowletCrank<I,O>{
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