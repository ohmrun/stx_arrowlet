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
  inline static public function fromFunction<A,B,C>(fn:A->B):Arrowlet<A,B>{
    return new FunctionArrowlet(fn);
  }
  inline static public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
    return fromSink(function(a:Tuple2<A,B>,b:Sink<C>){
      b(fn.tupled()(a));
    });
  }
}