package stx.arrowlet.core.body;

import stx.arrowlet.core.head.data.State in StateT;

class States{
  static public function change<S,A>(arw0:StateT<S,A>,arw1:Arrowlet<Tuple2<A,S>,S>):StateT<S,A>{
    return arw0.fan().then(arw1.second())
      .then(
        __.into2(
          (l:Tuple2<A,S>,r:S) -> tuple2(l.fst(),r)
        )
      );
  }
  static public function modify<S,A,B>(arw0:StateT<S,A>,arw1:Arrowlet<Tuple2<A,S>,B>):StateT<S,B>{
    return arw0.joint(arw1)
      .then(
        (t:Tuple2<Tuple2<A,S>,B>) -> __.into2(
         (l:Tuple2<A,S>,r:B) -> tuple2(r,l.snd())
        )(t)
      );
  }
  static public function put<S,A,B>(arw0:StateT<S,A>,v:S):StateT<S,A>{
    return Arrowlets._.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.fst(),v);
      }
    );
  }
  static public function ret<S,A>(arw0:StateT<S,A>):StateT<S,S>{
    return Arrowlets._.then(arw0,
      function(tp:Tuple2<A,S>){
        return tuple2(tp.snd(),tp.snd());
      }
    );
  }
  static public function request<S,A>(arw0:StateT<S,A>):Arrowlet<S,A>{
    return arw0.then(
      function(t:Tuple2<A,S>){
        return t.fst();
      }
    );
  }
  
  static public function resolve<S,A>(arw0:StateT<S,A>){
    return arw0.then(
      function(t:Tuple2<A,S>){
        return t.snd();
      }
    );
  }
  static public function breakout<S,A>(arw:StateT<S,A>):Arrowlet<S,A>{
    return arw.then(
      function(x:Tuple2<A,S>):A{
        return x.fst();
      }
    );
  }
}