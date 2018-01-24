package stx.arrowlet;

class Lift{
  @doc("Print the output of an Arrowlet")
  @:noUsing static public function printer<A,B>(a:Arrowlet<A,B>,?pos:haxe.PosInfos):Arrowlet<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x,pos) ; return x;};
    return new Then( a, m );
  }
  @:noUsing static public inline function fromSink<A,B>(fn:A -> Sink<B> -> Void):Arrowlet<A,B>{
      return LiftSinkToArrowlet.toArrowlet(fn);
  }
  @:noUsing static public inline function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>{
      return LiftFunctionToArrowlet.toArrowlet(fn);
  }
}

class LiftFutureConstructorToArrowlet{
    static public function toArrowlet<I,O>(fn:I->Future<O>):Arrowlet<I,O>{
        return function(i,cont){
        fn(i).handle(cont);
        return null;
        }
    }
}
class LiftSinkToArrowlet{
    static public function toArrowlet<A,B>(fn:A -> Sink<B> -> Void):Arrowlet<A,B>{
        return new Arrowlet(function(i:A,cont:Sink<B>):Block{
        var cancelled = false;

        if(!cancelled){
            fn(i,
            function(o){
                if(!cancelled){
                cont(o);
                }
            }
            );
        }
        return function(){
            cancelled = true;
        }
        });
    }
}
class LiftFunctionToArrowlet{
    inline static public function toArrowlet<A,B,C>(fn:A->B):Arrowlet<A,B>{
        return new FunctionArrowlet(fn);
    }
}
class LiftFunction2ToArrowlet{
    inline static public function toArrowlet<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
        return Lift.fromSink(function(a:Tuple2<A,B>,b:Sink<C>){
            b(fn.tupled()(a));
        });
    }
}
class LiftOptionArrowletToOnly{
    @doc("Takes an Arrowlet that produces an Option and returns one that takes an Option also.")
    static public function toOnly<I,O>(arw:Arrowlet<I,Option<O>>):Only<I,O>{
        return Arrowlets.flatten(LiftArrowletToOnly.toOnly(arw));
    }
}
class LiftArrowletToOnly{
    @doc("Produces an Arrowlet that is applied if the input is Some.")
    public static function toOnly<I,O>(a:Arrowlet<I,O>):Only<I,O>{
        return new Only(a);
    }
}
/*
class LiftArrowletToCrank{
    static public function toCrank<A,B>(arw:Arrowlet<A,B>):Crank<A,B>{
        return Cranks.manage(arw);
    }
}
class LiftArrowletChunkToCrank{
    static public function toCrank<A,B>(a:Arrowlet<A,Chunk<B>>):Crank<A,B>{
        return Cranks.attempt(a);
    }
}*/