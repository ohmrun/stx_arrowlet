package stx.arrowlet;

class Lift{
  static public function arrowlet<I,O>(stx:Stx<Wildcard>,c:Construct<I,O>):Arrowlet<I,O>{
    return c.reply();
  }
  @doc("Print the output of an Arrowlet")
  @:noUsing static public function printer<A,B>(a:Arrowlet<A,B>,?pos:haxe.PosInfos):Arrowlet<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x,pos) ; return x;};
    return new Then( a, m );
  }
  static public function then<A,B>(ft:Future<A>,then:Arrowlet<A,B>):Future<B>{
    return ft.flatMap(
      function(x:A){
        var trg = Future.trigger();
            then.withInput(x,trg.trigger);
        return trg.asFuture();
      }
    );
  }
}
class LiftFutureConstructorToArrowlet{
    static public function toArrowlet<I,O>(fn:I->Future<O>):Arrowlet<I,O>{
        return function(i:I,cont:Sink<O>){
            fn(i).handle(cont);
            return null;
        }
    }
}
class LiftZeroFutureConstructorToArrowlet{
    static public function toArrowlet<O>(fn:Void->Future<O>):Arrowlet<Noise,O>{
        return function(_:Noise,cont:Sink<O>){
            fn().handle(cont);
            return null;
        }
    }
}
class LiftHandlerToArrowlet{
    static public function toArrowlet<O>(fn:(O->Void)->Void):Arrowlet<Noise,O>{
        return function(_:Noise,cont:Sink<O>){
            fn(cont);
            return null;
        }
    }
}
class LiftThunk{
    static public function toArrowlet<O>(fn:Noise->O):Arrowlet<Noise,O>{
        return function(_:Noise,cont:Sink<O>){
            cont(fn(Noise));
            return null;
        }
    }
}
class LiftSinkToArrowlet{
    static public function toArrowlet<A,B>(fn:A -> Sink<B> -> Void):Arrowlet<A,B>{
        return new Arrowlet(function(_,cont:Sink<B>,i:A):Block{
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
        return function(a:Tuple2<A,B>,b:Sink<C>){
            b(a.into(fn));
            return ()->{};
        };
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