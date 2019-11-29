package stx.arrowlet.core.pack;

import stx.Vouch;
import stx.arrowlet.core.head.data.State     in StateT;
import stx.arrowlet.core.head.data.Windmill  in WindmillT;

@:callable @:forward abstract Windmill<S,A>(WindmillT<S,A>) from WindmillT<S,A> to WindmillT<S,A>{
  static public function pure<S,A>(a:A):Windmill<S,A>{
    return function(s:S,cont:Tuple2<Chunk<A>,S>->Void):Void{
      cont(tuple2(Val(a),s));
    }
  }
}
