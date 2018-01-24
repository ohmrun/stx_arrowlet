package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.Arrowlet in ArrowletT;
import stx.arrowlet.core.body.Arrowlets;

@:forward abstract Arrowlet<I,O>(ArrowletT<I,O>){
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
  static function lift<I,O>(arw:ArrowletT<I,O>):Arrowlet<I,O>{
    return new Arrowlet(arw);
  }
  public function apply(v:I):Future<O>{
    return Arrowlets.apply(new Arrowlet(this),v);
  }
  public function withInput(i:I,cont:Sink<O>):Block{
    return this(__,cont,i); 
  }
  public function then<N>(that:Arrowlet<O,N>):Arrowlet<I,N>{
    return Arrowlets.then(lift(this),that);
  }
  public function split<C>(that:Arrowlet<I, C>):Arrowlet<I, Tuple2<O,C>> {
    return Arrowlets.split(lift(this),that);
  }
  public function bind<C>(that:Arrowlet<Tuple2<I,O>,C>):Arrowlet<I,C>{
    return Arrowlets.bind(lift(this),that);
  }
  public function fan<I,O>():Arrowlet<I,Tuple2<O,O>>{
    return Arrowlets.fan(lift(this));
  }
  public function first<C>():Arrowlet<Tuple2<I,C>,Tuple2<O,C>>{
    return Arrowlets.first(lift(this));
  }
  public function second<C>():Arrowlet<Tuple2<C,I>,Tuple2<C,O>>{
    return Arrowlets.second(lift(this));
  }
  public function join<C>(that:Arrowlet<O,C>):Arrowlet<I,Tuple2<O,C>>{
    return Arrowlets.join(lift(this),that);
  }
  /*
  public function compose<N>(r:Arrowlet<N,I>):Arrowlet<N,O>{
    return Arrowlets.then(r,this);
  }*/
  
  public function new(self:ArrowletT<I,O>){
    this  = self;
  }
  @:from static public function fromFly<A,B>(fn:A->Sink<B>->Block):Arrowlet<A,B>{
    return new Arrowlet(
      (_,cont,i) -> fn(i,cont)
    );
  }  
  @:from static public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>{
    return Lift.fromFunction2(fn);
  }
  @:from static public function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>{
    return new FunctionArrowlet(fn);
  }
  /*
  @:from static public function fromArrowletT<A,B>(fn:Sink<B>->A->Block):Arrowlet<A,B>{
    return new Arrowlet(fn);
  }*/
  /*
  */
   /*
  public function bind<C>(bindr:Arrowlet<Tuple2<I,O>,C>):Arrowlet<I,C>{
    return Arrowlets.bind(new Arrowlet(this),bindr);
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
 
  
  @:from static inline public function fromEndo<A>(fn:A->A):Arrowlet<A,A>{
    return fromFunction(fn);
  }
  
  
  
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrowlet<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return Lift.fromSink(function(a:A,b:Sink<Tuple2<B,A>>){
      b(fn(a));
    });
  }*/
}