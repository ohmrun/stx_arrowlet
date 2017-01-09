package stx.async.arrowlet.body;

import stx.async.arrowlet.Package;

class Lift{
  static public function fromFuture<I,O>(fn:I->Future<O>):Arrowlet<I,O>{
    return function(i,cont){
      fn(i).handle(cont);
      return null;
    }
  }
  static public function fromSink<A,B>(fn:A -> Sink<B> -> Void):Arrowlet<A,B>{
    return new Arrowlet(function(i:A,cont:Sink<B>):CallbackLink{
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
  @:noUsing inline static public function fromFunction<A,B,C>(fn:A->B):Arrowlet<A,B>{
    return new FunctionArrowlet(fn);
  }
  @:noUsing inline static public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
    return fromSink(function(a:Tuple2<A,B>,b:Sink<C>){
      b(fn.tupled()(a));
    });
  }
  @doc("Takes an Arrowlet that produces an Option and returns one that takes an Option also.")
  static public function fromOption<I,O>(arw:Arrowlet<I,Option<O>>):Only<I,O>{
    return Arrowlets.flatten(only(arw));
  }
  @doc("Produces an Arrowlet that is applied if the input is Some.")
  @:noUsing public static function only<I,O>(a:Arrowlet<I,O>):Only<I,O>{
    return new Only(a);
  }
  @doc("Print the output of an Arrowlet")
  @:noUsing static public function printer<A,B>(a:Arrowlet<A,B>,?pos:haxe.PosInfos):Arrowlet<A,B>{
    var m : B->B = function(x:B):B { haxe.Log.trace(x,pos) ; return x;};
    return new Then( a, m );
  }
  static public function attempt<A,B>(a:Arrowlet<A,Chunk<B>>):Crank<A,B>{
    return Cranks.attempt(a);
  }
  static public function manage<A,B>(arw:Arrowlet<A,B>):Crank<A,B>{
    return Cranks.manage(arw);
  }
}