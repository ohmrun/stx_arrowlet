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
  public function wait(cont:Sink<O>):I->Block{
    return this.bind(__,cont);
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
  public function bound<C>(that:Arrowlet<Tuple2<I,O>,C>):Arrowlet<I,C>{
    return Arrowlets.bound(lift(this),that);
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
  public function joint<C>(that:Arrowlet<O,C>):Arrowlet<I,Tuple2<O,C>>{
    return Arrowlets.joint(lift(this),that);
  }
  public function compose<N>(r:Arrowlet<N,I>):Arrowlet<N,O>{
    return Arrowlets.then(r,lift(this));
  }
  
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
  public inline function tapO(fn:O->Void){
    return Arrowlets.tapO(lift(this),fn);
  }
  /*
  @:from static inline public function fromStateFunction<A,B>(fn:A->Tuple2<B,A>):Arrowlet<A,Tuple2<B,A>>{
    //trace('fromStateFunction');
    return Lift.fromSink(function(a:A,b:Sink<Tuple2<B,A>>){
      b(fn(a));
    });
  }*/
}