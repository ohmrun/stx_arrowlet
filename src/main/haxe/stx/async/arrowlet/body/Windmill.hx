package stx.async.arrowlet.body;

import stx.Vouch;
import stx.async.arrowlet.head.data.State     in TState;
import stx.async.arrowlet.head.data.Windmill  in TWindmill;

using stx.Pointwise;

using stx.Chunk;

@:callable @:forward abstract Windmill<S,A>(TWindmill<S,A>) from TWindmill<S,A> to TWindmill<S,A>{
  static public function pure<S,A>(a:A):Windmill<S,A>{
    return function(s:S,cont:Tuple2<Chunk<A>,S>->Void):Void{
      cont(tuple2(Val(a),s));
    }
  }
}
