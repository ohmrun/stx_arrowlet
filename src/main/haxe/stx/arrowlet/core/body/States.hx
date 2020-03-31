package stx.arrowlet.core.body;

import stx.arrowlet.core.head.data.State in StateT;

class States{
  static public function change<S,A>(self:StateT<S,A>,that:Arrowlet<Couple<A,S>,S>):StateT<S,A>{
    return self.fan().then(that.second())
      .postfix(
        __.decouple(
          (l:Couple<A,S>,r:S) -> __.couple(l.fst(),r)
        )
      );
  }
  static public function modify<S,A,B>(self:StateT<S,A>,that:Arrowlet<Couple<A,S>,B>):StateT<S,B>{
    return self.joint(that)
      .postfix(
        (t:Couple<Couple<A,S>,B>) -> __.decouple(
         (l:Couple<A,S>,r:B) -> __.couple(r,l.snd())
        )(t)
      );
  }
  static public function put<S,A,B>(self:StateT<S,A>,v:S):StateT<S,A>{
    return Arrowlet.inj()._.postfix(
      function(tp:Couple<A,S>){
        return __.couple(tp.fst(),v);
      },
      self
    );
  }
  static public function ret<S,A>(self:StateT<S,A>):StateT<S,S>{
    return Arrowlet.inj()._.postfix(
      function(tp:Couple<A,S>){
        return __.couple(tp.snd(),tp.snd());
      },
      self
    );
  }
  static public function request<S,A>(self:StateT<S,A>):Arrowlet<S,A>{
    return self.postfix(
      function(t:Couple<A,S>){
        return t.fst();
      }
    );
  }
  
  static public function resolve<S,A>(self:StateT<S,A>){
    return self.then(
      function(t:Couple<A,S>){
        return t.snd();
      }
    );
  }
  static public function breakout<S,A>(arw:StateT<S,A>):Arrowlet<S,A>{
    return arw.then(
      function(x:Couple<A,S>):A{
        return x.fst();
      }
    );
  }
}