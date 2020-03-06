package stx.arrowlet;

class Lift{
  static public function arrowlet<I,O>(stx:Wildcard,c:Construct<I,O>):Arrowlet<I,O>{
    return c.reply();
  }
  @doc("Print the output of an Arrowlet")
  @:noUsing static public function printer<A,B>(a:Arrowlet<A,B>,?pos:haxe.PosInfos):Arrowlet<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x,pos) ; return x;};
    return new Then( a, m );
  }
  static public function  arw(__:Wildcard){
    return new stx.arrowlet.core.Module();
  }

  static public function pinch<I,O1,O2>(a:Arrowlet<Tuple2<I,I>,Tuple2<O1,O2>>):Arrowlet<I,Tuple2<O1,O2>> return Arrowlets.fromPair(a);

}
class LiftFuture{
  static public function then<T,U>(ft:Future<T>,arw:Arrowlet<T,U>):Arrowlet<Noise,U>{
    return __.arw().cb()(
      (_:Noise,cb) -> ft.handle(cb)
    ).then(arw);
  }
}
class LiftFutureConstructorToArrowlet{
  static public function toArrowlet<I,O>(fn:I->Future<O>):Arrowlet<I,O>{
    return __.arw().cb()(
      (i,cont) -> fn(i).handle(cont)
    );
  }
}
class LiftZeroFutureConstructorToArrowlet{
    static public function toArrowlet<O>(fn:Void->Future<O>):Arrowlet<Noise,O>{
      return __.arw().cb()(
        (_:Noise,cb:O->Void) -> fn().handle(cb)
      );
    }
}
class LiftHandlerToArrowlet{
  static public function toArrowlet<O>(fn:(O->Void)->Void):Arrowlet<Noise,O>{
    return __.arw().cb()(
      (_:Noise,cb:O->Void) -> fn(cb)
    );
  }
}
class LiftThunk{
  static public function toArrowlet<O>(fn:Void->O):Arrowlet<Noise,O>{
    return __.arw().fn((_) -> fn());
  }
}
class LiftFunctionToArrowlet{
    inline static public function toArrowlet<A,B,C>(fn:A->B):Arrowlet<A,B>{
      return __.arw().fn(fn);
    }
}
class LiftFunction2ToArrowlet{
    inline static public function toArrowlet<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
      return __.arw().fn(__.into2(fn));
    }
}
// class LiftOptionArrowletToOnly{
//     @doc("Takes an Arrowlet that produces an Option and returns one that takes an Option also.")
//     static public function toOnly<I,O>(arw:Arrowlet<I,Option<O>>):Only<I,O>{
//         return Arrowlets.flatten(LiftArrowletToOnly.toOnly(arw));
//     }
// }
// class LiftArrowletToOnly{
//     @doc("Produces an Arrowlet that is applied if the input is Some.")
//     public static function toOnly<I,O>(a:Arrowlet<I,O>):Only<I,O>{
//         return new Only(a);
//     }
// }