package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.State in StateT;

@:forward @:callable abstract State<S,A>(StateT<S,A>) from StateT<S,A> to StateT<S,A>{
  public function new(self:StateT<S,A>){
    this = self;
  }
  @:noUsing static public function pure<S,A>(a:A):State<S,A>{
    return new State(Lift.fromFunction(function(s:S):Tuple2<A,S>{
      return tuple2(a,s);
    }));
  }
} 