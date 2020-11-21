package stx.arw;

import stx.arw.arrowlet.term.*;

@:using(stx.arw.arrowlet.ArrowletLift)
abstract Arrowlet<I,O,E>(ArrowletDef<I,O,E>) from ArrowletDef<I,O,E> to ArrowletDef<I,O,E>{
  
  private inline function new(self:ArrowletDef<I,O,E>) this  = self;
  static public var _(default,never) = stx.arw.arrowlet.ArrowletLift;

  @:noUsing static public inline function lift<I,O,E>(self:ArrowletDef<I,O,E>):Arrowlet<I,O,E>{
    return new Arrowlet(self);
  }
  static public function unit<I,E>():Arrowlet<I,I,E>{
    return lift(new Unit());
  }
  @:noUsing static public inline function pure<I,O,E>(o:O):Arrowlet<I,O,E>{
    return lift(new Pure(o));
  }
  @:noUsing static public inline function Sync<I,O,E>(self:I->O):Arrowlet<I,O,E>{
    return lift(new Sync(self));
  }
  @:noUsing static public inline function Then<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>,that:ArrowletDef<Oi,Oii,E>):Arrowlet<I,Oii,E>{
    return new Then(self,that);
  }
  @:noUsing static public inline function Anon<I,O,E>(fn:I->Terminal<O,E>->Work):Arrowlet<I,O,E>{
    return lift(new stx.arw.arrowlet.term.Anon(fn));
  }
  @:noUsing static public inline function Applier<I,O,E>():Arrowlet<Couple<Arrowlet<I,O,E>,I>,O,E>{
    return lift(new Applier());
  }
  @:noUsing static public inline function FlatMap<I,Oi,Oii,E>(self : Arrowlet<I,Oi,E>,func : Oi -> Arrowlet<I,Oii,E>):Arrowlet<I,Oii,E>{
    return lift(new FlatMap(self,func));
  }
  @:noUsing static public inline function Delay<I,E>(milliseconds:Int):Arrowlet<I,I,E>{
    return new stx.arw.arrowlet.term.Delay(milliseconds);
  }
  @:noUsing static public inline function SplitFun<P,Ri,Rii,E>(lhs:Internal<P,Ri,E>,rhs:P->Rii):Arrowlet<P,Couple<Ri,Rii>,E>{
    return new stx.arw.arrowlet.term.SplitFun(lhs,rhs);
  }
  @:noUsing static public inline function Fulfill<I,O,E>(self:Arrowlet<I,O,E>,input:I):Arrowlet<Noise,O,E>{
    return new stx.arw.arrowlet.term.Fulfill(self,input);
  }
  @:noUsing static public inline function Deliver<I,O,E>(self:Arrowlet<I,O,E>,success,failure):Arrowlet<I,Noise,Noise>{
    return new stx.arw.arrowlet.term.Deliver(self,success,failure);
  }
  @:noUsing static public inline function ThenArw<I,Oi,Oii,E>(self:I->Oi,fn:Arrowlet<Oi,Oii,E>):Arrowlet<I,Oii,E>{
    return stx.arw.arrowlet.term.ThenArw.make(self,fn);
  }
  @:noUsing static public inline function ThenFun<I,Oi,Oii,E>(self:Arrowlet<I,Oi,E>,fn:Oi->Oii):Arrowlet<I,Oii,E>{
    return new stx.arw.arrowlet.term.ThenFun(self,fn);
  }
  @:noUsing static public inline function ThenFunFun<I,Oi,Oii,E>(self:I->Oi,fn:Oi->Oii):Arrowlet<I,Oii,E>{
    return new stx.arw.arrowlet.term.ThenFunFun(self,fn);
  }
  @:noUsing static public inline function Fun1Future<I,O,E>(self:I->TinkFuture<O>):Arrowlet<I,O,E>{
    return lift(new Fun1Future(self));
  }
  @:noUsing static public inline function Future<O,E>(ft:TinkFuture<O>):Arrowlet<Noise,O,E>{
    return lift(new stx.arw.arrowlet.term.Future(ft));
  }
  @:from @:noUsing static public inline function fromFunXR<O,E>(f:Void->O):Arrowlet<Noise,O,E>{
    return lift(new Sync((_:Noise)->f()));
  }
  @:from @:noUsing static public inline function fromFun1R<I,O,E>(f:I->O):Arrowlet<I,O,E>{
    return lift(new Sync(f));
  }
  @:from @:noUsing static public inline function fromFun2R<Pi,Pii,R,E>(f:Pi->Pii->R):Arrowlet<Couple<Pi,Pii>,R,E>{
    return lift(new Sync(__.decouple(f)));
  }
  @:from @:noUsing static public inline function fromFunSink<I,O,E>(fn:I->(O->Void)->Void):Arrowlet<I,O,E>{
    return lift(new stx.arw.arrowlet.term.Raw(
      (i:I,cont) -> fn(i,(o) -> cont(__.success(o)))
    ));
  }
 public inline function environment(i:I,success:O->Void,failure:Defect<E>->Void):Fiber{
  return _.environment(this,i,success,failure);
 }
  //@:from static public function fromFunXX
  //@:from static public function fromFun1X
  @:allow(stx) @:to private inline function toInternal():Internal<I,O,E>{
    return Internal.lift(this);
  }
} 
