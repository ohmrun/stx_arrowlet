package stx.arrowlet.pack;

import stx.arrowlet.head.data.Arrowlet in ArrowletT;
import stx.arrowlet.body.Arrowlets;

@:forward @:callable abstract Arrowlet<I,O>(ArrowletT<I,O>) from ArrowletT<I,O>{
  @doc("Externally accessible constructor.")
  static public inline function arw<A>():Arrowlet<A,A>{
    return unit();
  }
  @doc("Simple case, return the input.")
  @:noUsing static public function unit<A>():Arrowlet<A,A>{
    return new Unit();
  }
  @doc("Produces an arrow returning `v`.")
  @:noUsing static public function pure<A,B>(v:B):Arrowlet<A,B>{
    return Lift.fromSink(function(a:A,cont:Sink<B>){
      cont(v);
    });
  }
  public function apply(v:I):Future<O>{
    return Arrowlets.apply(this,v);
  }
  public function then<N>(r:Arrowlet<O,N>):Arrowlet<I,N>{
    return Arrowlets.then(this,r);
  }
  public function compose<N>(r:Arrowlet<N,I>):Arrowlet<N,O>{
    return Arrowlets.then(r,this);
  }
  public function bind<C>(bindr:Arrowlet<Tuple2<I,O>,C>):Arrowlet<I,C>{
    return Arrowlets.bind(this,bindr);
  }
  public function new(v:ArrowletT<I,O>){
    this  = v;
  }
  
  @:from static inline public function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>{
    return new FunctionArrowlet(fn);
  }
  @:from static inline public function fromSink<A,B>(fn:A -> Sink<B> -> Void):Arrowlet<A,B>{
    return Lift.fromSink(fn);
  }
  public function fan():Arrowlet<I,Tuple2<O,O>>{
    return Arrowlets.fan(this);
  }
  public function second<C>():Arrowlet<Tuple2<C,I>,Tuple2<C,O>>{
    return Arrowlets.second(this);
  }
  public function join<C>(that:Arrowlet<O,C>):Arrowlet<I,Tuple2<O,C>>{
    return Arrowlets.join(this,that);
  }
  /*
  
  @:from static inline public function fromEndo<A>(fn:A->A):Arrowlet<A,A>{
    return fromFunction(fn);
  }
  
  @:from static inline public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
    return Lift.fromFunction2(fn);
  }
  
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrowlet<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return Lift.fromSink(function(a:A,b:Sink<Tuple2<B,A>>){
      b(fn(a));
    });
  }*/
}

class FutureArrows{
  static public function then<A,B>(ft:Future<A>,then:Arrowlet<A,B>):Future<B>{
    return ft.flatMap(
      function(x:A){
        var trg = Future.trigger();
            then(x,trg.trigger);
        return trg.asFuture();
      }
    );
  }
}