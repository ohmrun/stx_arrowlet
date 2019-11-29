package stx.arrowlet.core.pack;

import stx.core.pack.body.Vouches;
import stx.arrowlet.core.head.data.Spawn in SpawnT;

abstract Spawn<T,E>(SpawnT<T,E>) from SpawnT<T,E> to SpawnT<T,E>{
  static public inline function spawn<T,E>(arw):Spawn<T,E>{
    return new Spawn(arw);
  }
  @:noUsing static public function pure<T,E>(v:T):Spawn<T,E>{
    return new Spawn((_:Noise,cont:Sink<Chunk<T,E>>) -> {
      cont(Val(v));
      return ()->{};
    });
  }
  @:noUsing static public function unit<T,E>():Spawn<T,E>{
    return function(u:Noise) return Tap;
  }
  public function new(v){
    this = v;
  }
  public function map<B>(arw:Arrowlet<T,B>):Spawn<B,E>{
    return this.then(
      function(chk:Chunk<T,E>,cont:Sink<Chunk<B,E>>){
        chk.fold(
          arw.then(Val).apply,
          function(x) return Vouch.end(x).prj(),
          () -> Vouch.tap().prj()
        ).handle(cont);
        return ()->{}
      }
    );
  }
  public function attempt<B>(arw:Arrowlet<T,Chunk<B,E>>):Spawn<B,E>{
    return this.then(
      function(chk:Chunk<T,E>,cont:Sink<Chunk<B,E>>){
        chk.fold(
          arw.apply,
          function(x) return End(x),
          () -> Vouch.tap().prj()
        ).handle(cont);
        return () -> {};
      }
    );
  }
  public function split<B>(spn1:SpawnT<B,E>):Spawn<Tuple2<T,B>,E>{
    return new Spawn(
      Arrowlets.split(this,spn1).then(
        (t:Tuple2<Chunk<T,E>,Chunk<B,E>>) -> t.into(
          (l,r) -> l.zip(r)
        )
      )
    );
  }
  public function fold<B>(fn:T->B,er:Null<TypedError<E>>->B,nil:Void->B):Arrowlet<Noise,B>{
    return (_:Noise, cont:Sink<B>) -> {
      this.apply(Noise).handle(
        (chk) -> cont(
          chk.fold(
            fn,
            er,
            nil
          )
        )
      );
      return () -> {};
    }
  }
  // public function breakoutUsing(er:Null<Error>->T,nil:Void->T):Arrowlet<Noise,T>{
  //   return function(x:Noise):Future<T,E>{
  //     return Arrowlets.then(this,
  //       function(chk:Chunk<T,E>){
  //         return chk.fold(
  //           Compose.unit(),
  //           er,
  //           nil
  //         );
  //       }
  //     ).apply(x);
  //   }
  // }
  /*
  public function toCrank<B>():Crank<B,T>{
    return function(x:Chunk<B>){
      return this.apply(Unit);
    }.lift();
  }*/
}
