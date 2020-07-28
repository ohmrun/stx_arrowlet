package stx.arw;

import stx.arw.arrowlet.term.Both;
import stx.arw.arrowlet.term.Bound;
import stx.arw.arrowlet.term.Delay;
import stx.arw.arrowlet.term.Fan;
import stx.arw.arrowlet.term.Fun1Future;
import stx.arw.arrowlet.term.Future;
import stx.arw.arrowlet.term.Handler;

import stx.arw.arrowlet.term.Or;
import stx.arw.arrowlet.term.ReplyFuture;
import stx.arw.arrowlet.term.Split;
import stx.arw.arrowlet.term.Sync;
import stx.arw.arrowlet.term.Then;
import stx.arw.arrowlet.term.Thread;
import stx.arw.arrowlet.term.Pure;
import stx.arw.arrowlet.term.FlatMap;
import stx.arw.arrowlet.term.Inform;

interface ArrowletApi<P,O,E>{
	public function applyII(p:P,t:Terminal<O,E>):Work;
	private function doApplyII(p:P,t:Terminal<O,E>):Work;
  public function asArrowletDef():ArrowletDef<P,O,E>;
}
class ArrowletBase<P,O,E> implements ArrowletApi<P,O,E>{
	public function new(){}
	public function applyII(p:P,t:Terminal<O,E>):Work{
		var output = doApplyII(p,t);
		return output;
	}
	private function doApplyII(p:P,t:Terminal<O,E>):Work{
    return throw __.fault().err(E_AbstractMethod);
  }
  public function asArrowletDef():ArrowletDef<P,O,E>{
    return this;
  }
}
typedef ArrowletDef<P,O,E>       = {
  public function applyII(p:P,t:Terminal<O,E>):Work;
  public function asArrowletDef():ArrowletDef<P,O,E>;
}
@:using(stx.arw.Arrowlet.ArrowletLift)
@:forward(applyII,asArrowletDef)
abstract Arrowlet<I,O,E>(ArrowletDef<I,O,E>) from ArrowletDef<I,O,E> to ArrowletDef<I,O,E>{
  
  private function new(self:ArrowletDef<I,O,E>) this  = self;
  static public var _(default,never) = ArrowletLift;

  @:noUsing static public function lift<I,O,E>(self:ArrowletDef<I,O,E>):Arrowlet<I,O,E>{
    return new Arrowlet(self);
  }
  static public function unit<I,E>():Arrowlet<I,I,E>{
    return lift(new Sync((i:I) -> i).asArrowletDef());
  }
  @:noUsing static public function pure<I,O,E>(o:O):Arrowlet<I,O,E>{
    return lift(new Pure(o));
  }
  #if stx_log
  @:noUsing static public function logger<I,E>(?log,?pos:Pos):Arrowlet<I,I,E>{
    if(log == null){
      log = __.log();
    }
    return lift(new Sync(
      function(i:I){
        log(i,pos);
        return i;
      }
    ));
  }
  #end
  @:noUsing static public function Sync<I,O,E>(self:I->O):Arrowlet<I,O,E>{
    return lift(new Sync(self));
  }
  @:noUsing static public function Then<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>,that:ArrowletDef<Oi,Oii,E>):Arrowlet<I,Oii,E>{
    return new Then(self,that);
  }
  @:noUsing static public function Anon<I,O,E>(fn:I->Terminal<O,E>->Work):Arrowlet<I,O,E>{
    return lift(new stx.arw.arrowlet.term.Anon(fn));
  }
  @:noUsing static public function Apply<I,O,E>():Arrowlet<Couple<Arrowlet<I,O,E>,I>,O,E>{
    return lift(new Apply());
  }
  @:noUsing static public function FlatMap<I,Oi,Oii,E>(self : Arrowlet<I,Oi,E>,func : Oi -> Arrowlet<I,Oii,E>):Arrowlet<I,Oii,E>{
    return lift(new FlatMap(self,func));
  }
  @:noUsing static public function Future<O,E>(ft:TinkFuture<O>):Arrowlet<Noise,O,E>{
    return lift(new Future(ft));
  }
  @:from @:noUsing static public function fromFunXR<O>(f:Void->O):Arrowlet<Noise,O,Dynamic>{
    return lift(new Sync((_:Noise)->f()));
  }
  @:from @:noUsing static public function fromFun1R<I,O,E>(f:I->O):Arrowlet<I,O,E>{
    return lift(new Sync(f));
  }
  @:from @:noUsing static public function fromFun2R<Pi,Pii,R,E>(f:Pi->Pii->R):Arrowlet<Couple<Pi,Pii>,R,E>{
    return lift(new Sync(__.decouple(f)));
  }
  @:from @:noUsing static public function fromFunSink<I,O,E>(fn:I->(O->Void)->Void):Arrowlet<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (i:I,term:Terminal<O,E>) -> {
          return term.defer(
            Slot.fromFunSinkVoid(fn.bind(i)).map(Success)
          ).serve();
        }
      )
    );
  }
 public function environment(i:I,success:O->Void,failure:E->Void):Thread{
  return _.environment(this,i,success,failure);
 }
  //@:from static public function fromFunXX
  //@:from static public function fromFun1X
}
class ArrowletLift{
  static public function unto<I,O,E>(t:ArrowletDef<I,O,E>):Arrowlet<I,O,E>{
    return lift(t.asArrowletDef());
  }
  static private function lift<I,O,E>(def:Arrowlet<I,O,E>):Arrowlet<I,O,E>{
    return Arrowlet.lift(def);
  }
  static public function inject<I,Oi,Oii,E>(self:Arrowlet<I,Oi,E>,v:Oii):Arrowlet<I,Oii,E>{
    return then(self,Arrowlet.fromFun1R((b:Oi) -> v));
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  static public function then<I,Oi,Oii,E>(lhs:Arrowlet<I,Oi,E>,rhs:Arrowlet<Oi,Oii,E>):Arrowlet<I,Oii,E> {
    return unto(Arrowlet.Then(lhs,rhs));
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Couple that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  static public function first<Ii,Iii,O,E>(self:Arrowlet<Ii,O,E>):Arrowlet<Couple<Ii,Iii>,Couple<O,Iii>,E>{
    return both(self,Arrowlet.unit());
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Couple that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  static public function second<Ii,O,Iii,E>(self:Arrowlet<Ii,O,E>):Arrowlet<Couple<Iii,Ii>,Couple<Iii,O>,E>{
    return both(Arrowlet.unit(),self);
  }
  @doc("Takes two Arrowlets with the same input type, and produces one which applies each Arrowlet with the same input.")
  static public function split<I, Oi, Oii,E>(lhs:Arrowlet<I, Oi,E>,rhs:Arrowlet<I, Oii,E>):Arrowlet<I, Couple<Oi,Oii>,E> {
    return unto(new Split(lhs,rhs));
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  static public function both<Ii,Oi,Iii,Oii,E>(lhs:Arrowlet<Ii,Oi,E>,rhs:Arrowlet<Iii,Oii,E>):Arrowlet<Couple<Ii,Iii>,Couple<Oi,Oii>,E>{
    return unto(new Both(lhs,rhs));
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  static public function swap<I,Oi,Oii,E>(self:Arrowlet<I,Couple<Oi,Oii>,E>):Arrowlet<I,Couple<Oii,Oi>,E>{
    return self.then((tp:Couple<Oi,Oii>) -> tp.swap());
  }
  @doc("Produces a Couple output of any Arrowlet.")
  static public function fan<I,O,E>(self:Arrowlet<I,O,E>):Arrowlet<I,Couple<O,O>,E>{
    return self.postfix((v) -> __.couple(v,v));
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  static public function joint<I,Oi,Oii,E>(lhs:Arrowlet<I,Oi,E>,rhs:Arrowlet<Oi,Oii,E>):Arrowlet<I,Couple<Oi,Oii>,E>{
    return lhs.then(Arrowlet.unit().split(rhs));
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  static public function bound<I,Oi,Oii,E>(lhs:Arrowlet<I,Oi,E>,rhs:Arrowlet<Couple<I,Oi>,Oii,E>):Arrowlet<I,Oii,E>{
    return unto(new Bound(lhs,rhs));
  }
  // @doc("Runs an Arrowlet until it returns Done(out).")
  // static public function repeat<I,O>(a:Arrowlet<I,tink.Either<I,O>>):Repeat<I,O>{
  //   return new Repeat(a);
  // }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<Ii,Iii,O,E>(lhs:Arrowlet<Ii,O,E>,rhs:Arrowlet<Iii,O,E>):Arrowlet<Either<Ii,Iii>,O,E>{
    return lift(new Or(lhs, rhs).asArrowletDef());
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  static public function left<I,Oi,Oii,E>(self:Arrowlet<I,Oi,E>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>,E>{
    return LiftToLeftChoice.toLeftChoice(self);
  }
  //@doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  // static public function race<A,B>(lhs:Arrowlet<A,B>,rhs:Arrowlet<A,B>):Amb<A,B>{
  //  return new Amb(lhs,rhs);
  //}
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  static public function right<I,Oi,Oii,E>(self:Arrowlet<I,Oi,E>):Arrowlet<Either<Oii,I>,Either<Oii,Oi>,E>{
    return LiftToRightChoice.toRightChoice(self);
  }
  /*
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  static public function fromRight<A,B,C,D>(arr:Arrowlet<B,Either<C,D>>):Arrowlet<Either<C,B>,Either<C,D>>{
    return new RightSwitch(arr);
  }*/
  static public function prefix<Ii,Iii,O,E>(self:Arrowlet<Iii,O,E>,fn:Ii->Iii):Arrowlet<Ii,O,E>{
    return unto(new Sync(fn)).then(self);
  }
  static public function postfix<I,Oi,Oii,E>(self:Arrowlet<I,Oi,E>,fn:Oi->Oii):Arrowlet<I,Oii,E>{
    return self.then(unto(new Sync(fn)));
  }
  /**
    * Asynchronous version of `FlatMap`
  **/
  static public function inform<I,Oi,Oii,E>(lhs:Arrowlet<I,Oi,E>,rhs:Arrowlet<Oi,Arrowlet<Oi,Oii,E>,E>):Arrowlet<I,Oii,E>{
    return unto(new Inform(lhs,rhs));
  }
  static public function broach<I,O,E>(self:Arrowlet<I,O,E>):Arrowlet<I,Couple<I,O>,E>{
    return bound(self,Arrowlet.fromFun2R(__.couple));
  }
  static public function state<I,O,E>(self:Arrowlet<I,O,E>):Arrowlet<I,Couple<O,I>,E>{
    return bound(self,Arrowlet.fromFun2R(__.couple.fn().then(tp -> tp.swap())));
  }
  static public function fulfill<I,O,E>(self:Arrowlet<I,O,E>,i:I):Arrowlet<Noise,O,E>{
    return unto(Arrowlet.Anon(
      (_:Noise,cont:Terminal<O,E>) -> self.prepare(i,cont)
    ));
  }
  static public function deliver<I,O,E>(self:Arrowlet<I,O,E>,cb:O->Void):Arrowlet<I,Noise,E>{
    return Arrowlet.Then(
      self,
      Arrowlet.Sync((o) -> {
        cb(o);
        return Noise;
      })
    );
  }

  static public function prepare<I,O,E>(self:Arrowlet<I,O,E>,i:I,cont:Terminal<O,E>):Work{
    //__.assert().exists(self);
    return self.applyII(i,cont); 
  }
  @:noUsing static public inline function environment<I,O,E>(self:Arrowlet<I,O,E>,i:I,success:O->Void,failure:E->Void):Thread{
    return Arrowlet.Anon(
      (_:Noise,cont:Terminal<Noise,Noise>) -> {
        var defer = TinkFuture.trigger();
        var inner = cont.inner(
              (outcome:Outcome<O,E>) -> {
                outcome.fold(
                  success,
                  failure
                );
                defer.trigger(Success(Noise));
              }
            );
        return 
          cont.defer(defer.toSlot())
              .after(self.prepare(i,inner));
      }
    );
  }
  static public function fudge<I,O,E>(self:Arrowlet<I,O,E>,i:I):O{
    var v = null;
    function fn(x){
      v = x;
    }
    environment(self,i,
      fn,
      __.crack  
    ).crunch();

    return v;
  }
  static public function flat_map<I,Oi,Oii,E>(self:Arrowlet<I,Oi,E>,fn:Oi->Arrowlet<I,Oii,E>):Arrowlet<I,Oii,E>{
    return unto(new FlatMap(self,fn));
  }
  static public function pinch<I,O1,O2,E>(a:Arrowlet<Couple<I,I>,Couple<O1,O2>,E>):Arrowlet<I,Couple<O1,O2>,E>{
    return then(fan(Arrowlet.unit()),a);
  }
} 