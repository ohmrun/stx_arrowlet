package stx.arrowlet.core.pack;

import stx.arrowlet.core.head.data.Arrowlet in ArrowletT;


@:forward abstract Arrowlet<I,O>(ArrowletT<I,O>){

  public function new(self:ArrowletT<I,O>) this  = self;
  @:noUsing static public function lift<I,O>(arw:ArrowletT<I,O>):Arrowlet<I,O>               return new Arrowlet(arw);
  
  @:from static public function fromFunction2<A,B,C>(fn:A->B->C):Arrowlet<Tuple2<A,B>,C>     return fromFunction(__.into2(fn));
  @:from static public function fromFunction<A,B>(fn:A->B):Arrowlet<A,B>                     return new FunctionArrowlet(fn);

  @:noUsing static public function unit<A>():Arrowlet<A,A>                                   return new Unit();
  
  public function fulfill(v:I):Arrowlet<Noise,O>                         return Arrowlets._.fulfill(self,v);
  public function deliver(cb:O->Void):Arrowlet<I,Noise>                  return Arrowlets._.deliver(self,cb);
  
  @:deprecated
  public function withInput(i:I,cont:Sink<O>):Automation                        return this(__,cont,i); 
  public function prepare(i:I,cont:Sink<O>):Automation                          return this(__,cont,i); 
  public function receive(i:I):Receiver<O>                                        return Arrowlets._.receive(self,i);
  
  public function then<N>(that:Arrowlet<O,N>):Arrowlet<I,N>                       return Arrowlets._.then(self,that);
  public function both<I0,O0>(that:Arrowlet<I0,O0>):Both<I,O,I0,O0>               return Arrowlets._.both(self,that);
  public function split<C>(that:Arrowlet<I, C>):Arrowlet<I, Tuple2<O,C>>          return Arrowlets._.split(self,that);
  public function bound<C>(that:Arrowlet<Tuple2<I,O>,C>):Arrowlet<I,C>            return Arrowlets._.bound(self,that);
  public function broach():Arrowlet<I,Tuple2<I,O>>                                return Arrowlets._.bound(self,unit());
  public function fan():Arrowlet<I,Tuple2<O,O>>                                   return Arrowlets._.fan(self);
  public function first<C>():Arrowlet<Tuple2<I,C>,Tuple2<O,C>>                    return Arrowlets._.first(self);
  public function second<C>():Arrowlet<Tuple2<C,I>,Tuple2<C,O>>                   return Arrowlets._.second(self);
  public function joint<C>(that:Arrowlet<O,C>):Arrowlet<I,Tuple2<O,C>>            return Arrowlets._.joint(self,that);
  public function compose<N>(r:Arrowlet<N,I>):Arrowlet<N,O>                       return Arrowlets._.then(r,self);
  public function tapO(fn:O->Void)                                                return Arrowlets._.tapO(self,fn);
  public function only():Only<I,O>                                                return new Only(self);
  public function choose<R>(arw:Arrowlet<O,Arrowlet<O,R>>):Arrowlet<I,R>          return Arrowlets._.choose(self,arw);
  public function or<II>(that:Arrowlet<II,O>):Arrowlet<Either<I,II>,O>            return Arrowlets._.or(self,that);
  
  public function postfix<R>(fn:O->R):Arrowlet<I,R>                               return Arrowlets._.postfix(self,fn);
  public function prefix<P>(fn:P->I):Arrowlet<P,O>                                return Arrowlets._.prefix(self,fn);
  


  

  var self(get,never) : Arrowlet<I,O>;
  function get_self():Arrowlet<I,O> return lift(this);
  public function prj():ArrowletT<I,O> return this;
}