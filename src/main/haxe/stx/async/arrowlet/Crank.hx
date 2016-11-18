package stx.async.arrowlet;


import stx.data.Block;

import stx.Maybe;

import stx.Chunk;
import stx.Error;

import tink.core.Future;
import tink.core.Noise;
import tink.core.Callback;

using stx.Tuple;

import stx.async.arrowlet.State;
using stx.async.Arrowlet;


using stx.async.Arrowlet;
using stx.async.arrowlet.Crank;
using stx.Pointwise;
//using stx.Compose;
//using stx.Compose;

using stx.Chunk;


typedef ArrowletCrank<I,O> = Arrowlet<Chunk<I>,Chunk<O>>;

@:forward @:callable abstract Crank<I,O>(ArrowletCrank<I,O>) from ArrowletCrank<I,O> to ArrowletCrank<I,O>{
  /*
  @:from static public function fromCreateArrow<I,O>(arw:Arrowlet<I,Chunk<O>>):Crank<I,O>{
    return function(x:Chunk<I>,cont:(Chunk<O> -> Void) -> Void){
      switch()
    }
  }*/
  public function imply(v:I):Future<Chunk<O>>{
    return Cranks.imply(this,v);
  }
}
class Cranks{
  static public function imply<A,B>(arw:ArrowletCrank<A,B>,v:A):Future<Chunk<B>>{
    return arw.apply(Chunks.create(v));
  }
  static public function apply<A,B>(arw:ArrowletCrank<A,B>,v:Chunk<A>):Future<Chunk<B>>{
    return Arrowlets.apply(arw,v);
  }
  static public function recover<A>(arw:Arrowlet<Error,A>):Arrowlet<Chunk<A>,Chunk<A>>{
    return function(chk:Chunk<A>,cont:Callback<Chunk<A>>):Maybe<Block>{
      switch(chk){
        case Val(v) : cont.invoke(Val(v));
        case End(e) : arw(e,Val.then(cont.invoke));
        case Nil    : cont.invoke(Nil);
      }
      return null;
    }
  }
  static public function resume<A>(arw:Arrowlet<Noise,A>):Arrowlet<Chunk<A>,Chunk<A>>{
    return function(chk:Chunk<A>,cont:Callback<Chunk<A>>){
      switch(chk){
        case Val(v) : cont.invoke(Val(v));
        case End(e) : cont.invoke(End(e));
        case Nil    : arw.withInput(Noise,Val.then(cont.invoke));
      }
      return null;
    }
  }
  static public function attempt<A,B>(arw:Arrowlet<A,Chunk<B>>):Arrowlet<Chunk<A>,Chunk<B>>{
    return function(chk:Chunk<A>,cont:Callback<Chunk<B>>){
      switch(chk){
        case Val(v) : arw.withInput(v,cont.invoke);
        case End(e) : cont.invoke(End(e));
        case Nil    : cont.invoke(Nil);
      }
      return null;
    }
  }
  static public function manage<A,B>(arw:Arrowlet<A,B>):Arrowlet<Chunk<A>,Chunk<B>>{
    return function(chk:Chunk<A>,cont:Callback<Chunk<B>>){
      switch(chk){
        case Val(v) : arw.withInput(v,Val.then(cont.invoke));
        case End(e) : cont.invoke(End(e));
        case Nil    : cont.invoke(Nil);
      }
      return null;
    }
  }
  static public function execute<A>(arw:Arrowlet<Chunk<A>,Chunk<Bool>>,?err:Error):Arrowlet<Chunk<A>,Chunk<A>>{
    err = err == null ? new Error(500,'execution failed') : err;
    return function(chk:Chunk<A>,cont:Callback<Chunk<A>>){
      arw.withInput(chk,
        function(chk0){
          switch(chk0){
            case Val(v)   :
              if (v==true){
                cont.invoke(chk);
              }else{
                cont.invoke(End(err));
              }
            case End(e) : cont.invoke(End(e));
            case Nil    : cont.invoke(Nil);
          }
        }
      );
      return null;
    }
  }
  /*
  static public function and<A>(arw0:Arrowlet<Chunk<A>,Chunk<Bool>>,arw1:Arrowlet<Chunk<A>,Chunk<Bool>>):Arrowlet<Chunk<A>,Chunk<Bool>>{
    var a = arw0.split(arw1).then(Chunks.zip.tupled());
    var b = a.then(
      stx.Bools.and.tupled().editor());
    return b;
  }*/
}
