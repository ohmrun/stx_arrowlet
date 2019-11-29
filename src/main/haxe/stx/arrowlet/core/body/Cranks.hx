package stx.arrowlet.core.body;

import stx.arrowlet.core.head.data.Crank in CrankT;

class Cranks{
  static public function imply<A,B,E>(arw:CrankT<A,B,E>,v:A):Future<Chunk<B,E>>{
    return arw.apply(Chunk.pure(v));
  }
  static public function apply<A,B,E>(arw:CrankT<A,B,E>,v:Chunk<A,E>):Future<Chunk<B,E>>{
    return Arrowlets.apply(arw,v);
  }
  static public function recover<A,E>(arw:Arrowlet<E,A>):Arrowlet<Chunk<A,E>,Chunk<A,E>>{
    return function(chk:Chunk<A,E>,cont:Sink<Chunk<A,E>>):Block{
      switch(chk){
        case Val(v) : cont(Val(v));
        case End(e) : 
          arw.then(Val).withInput(
            e,
            cont
          );
        case Tap    : cont(Tap);
      }
      return ()->{};
    }
  }
  static public function resume<A,E>(arw:Arrowlet<Noise,A>):Arrowlet<Chunk<A,E>,Chunk<A,E>>{
    return function(chk:Chunk<A,E>,cont:Sink<Chunk<A,E>>){
      switch(chk){
        case Val(v) : cont(Val(v));
        case End(e) : cont(End(e));
        case Tap    : arw.then(Val).withInput(Noise,cont);
      }
      return ()->{};
    }
  }
  @:noUsing static public function attempt<A,B,E>(arw:Arrowlet<A,Chunk<B,E>>):Arrowlet<Chunk<A,E>,Chunk<B,E>>{
    return function(chk:Chunk<A,E>,cont:Sink<Chunk<B,E>>){
      switch(chk){
        case Val(v) : arw.withInput(v,cont);
        case End(e) : cont(End(e));
        case Tap    : cont(Tap);
      }
      return ()->{};
    }
  }
  static public function resolve<A,B,E>(arw:Arrowlet<Chunk<A,E>,B>):Arrowlet<Chunk<A,E>,Chunk<B,E>>{
    return function(chk:Chunk<A,E>,cont:Sink<Chunk<B,E>>){
      arw.withInput(
        chk,
        function(b:B){
          return cont(Val(b));
        }
      );
      return ()->{};
    }
  }
  static public function manage<A,B,E>(arw:Arrowlet<A,B>):Arrowlet<Chunk<A,E>,Chunk<B,E>>{
    return function(chk:Chunk<A>,cont:Sink<Chunk<B>>){
      switch(chk){
        case Val(v) : arw.then(Val).withInput(v,cont);
        case End(e) : cont(End(e));
        case Tap    : cont(Tap);
      }
      return ()->{};
    }
  }
  static public function executor<A,E>(arw:Arrowlet<Chunk<A,TypedError<E>>,Chunk<Bool,E>>,?err:TypedError<E>):Arrowlet<Chunk<A,TypedError<E>>,Chunk<A,TypedError<E>>>{
    err = err == null ? new Error(500,'execution failed') : err;
    return function(chk:Chunk<A,E>,cont:Sink<Chunk<A,E>>){
      arw.withInput(chk,
        function(chk0){
          switch(chk0){
            case Val(v)   :
              if (v==true){
                cont(chk);
              }else{
                cont(End(err));
              }
            case End(e) : cont(End(e));
            case Tap    : cont(Tap);
          }
        }
      );
      return ()->{};
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
