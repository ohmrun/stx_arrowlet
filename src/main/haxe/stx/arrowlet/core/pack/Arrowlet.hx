package stx.arrowlet.core.pack;

import stx.arrowlet.core.pack.arrowlet.term.Both;
import stx.arrowlet.core.pack.arrowlet.term.Bound;
import stx.arrowlet.core.pack.arrowlet.term.Delay;
import stx.arrowlet.core.pack.arrowlet.term.Fan;
import stx.arrowlet.core.pack.arrowlet.term.Fun1Future;
import stx.arrowlet.core.pack.arrowlet.term.Future;
import stx.arrowlet.core.pack.arrowlet.term.Handler;
import stx.arrowlet.core.pack.arrowlet.term.InputReactor;
import stx.arrowlet.core.pack.arrowlet.term.InputReceiver;
import stx.arrowlet.core.pack.arrowlet.term.Or;
import stx.arrowlet.core.pack.arrowlet.term.ReplyFuture;
import stx.arrowlet.core.pack.arrowlet.term.Split;
import stx.arrowlet.core.pack.arrowlet.term.Sync;
import stx.arrowlet.core.pack.arrowlet.term.Then;
import stx.arrowlet.core.pack.arrowlet.term.Pure;
import stx.arrowlet.core.pack.arrowlet.term.FlatMap;
import stx.arrowlet.core.pack.arrowlet.term.Inform;

@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:forward(applyII,asRecallDef)
abstract Arrowlet<I,O>(ArrowletDef<I,O>) from ArrowletDef<I,O> to ArrowletDef<I,O>{
  private function new(self:ArrowletDef<I,O>) this  = self;
  static public var _(default,never) = ArrowletLift;

  static public function lift<I,O>(self:ArrowletDef<I,O>):Arrowlet<I,O>{
    return new Arrowlet(self);
  }
  static public function unto<T:RecallDef<I,O,Automation>,I,O>(t:T):Arrowlet<I,O>{
    return lift(t.asRecallDef());
  }
  static public function unit<I>():Arrowlet<I,I>{
    return lift(new Sync((i:I) -> i).asRecallDef());
  }
  static public function pure<I,O>(o:O):Arrowlet<I,O>{
    return unto(new Pure(o));
  }

  static public function Apply<I,O>():Arrowlet<Couple<Arrowlet<I,O>,I>,O>{
    return unto(new Apply());
  }
  @:from static public function fromRecallFun<I,O>(fun:RecallFun<I,O,Void>):Arrowlet<I,O>{
    return lift(new InputReactor(fun).asRecallDef());
  }
  @:from static public function fromFunXR<O>(f:Void->O):Arrowlet<Noise,O>{
    return lift(new Sync((_:Noise)->f()));
  }
  @:from static public function fromFun1R<I,O>(f:I->O):Arrowlet<I,O>{
    return lift(new Sync(f));
  }
  @:from static public function fromFun2R<PI,PII,R>(f):Arrowlet<Couple<PI,PII>,R>{
    return lift(new Sync(__.decouple(f)));
  }
  @:from static public function fromInputReactor<I,O>(f:I->(O->Void)->Void):Arrowlet<I,O>{
    return fromRecallFun(f);
  }
  @:from static public function fromInputReceiver<I,O>(f:I->Receiver<O>):Arrowlet<I,O>{
    return lift(new InputReceiver(f).asRecallDef());
  }
  //@:from static public function fromFunXX
  //@:from static public function fromFun1X
}
class ArrowletLift{
  
  static public function unto<I,O>(t:RecallDef<I,O,Automation>):Arrowlet<I,O>{
    return lift(t.asRecallDef());
  }
  static private function lift<I,O>(def:Arrowlet<I,O>):Arrowlet<I,O>{
    return Arrowlet.lift(def);
  }
  static public function inject<I,Oi,Oii>(self:Arrowlet<I,Oi>,v:Oii):Arrowlet<I,Oii>{
    return then(self,Arrowlet.fromFun1R((b:Oi) -> v));
  }
  static public function receive<I,O>(self:Arrowlet<I,O>,i:I):Receiver<O>{
    return Receiver.into(prepare.bind(self,i,_));
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  static public function then<I,Oi,Oii>(lhs:Arrowlet<I,Oi>,rhs:Arrowlet<Oi,Oii>):Arrowlet<I,Oii> {
    return unto(new Then(lhs,rhs));
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Couple that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  static public function first<Ii,Iii,O>(self:Arrowlet<Ii,O>):Arrowlet<Couple<Ii,Iii>,Couple<O,Iii>>{
    return both(self,Arrowlet.unit());
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Couple that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  static public function second<Ii,O,Iii>(self:Arrowlet<Ii,O>):Arrowlet<Couple<Iii,Ii>,Couple<Iii,O>>{
    return both(Arrowlet.unit(),self);
  }
  @doc("Takes two Arrowlets with thstatic static public function pure<I,O>(o:O):Arrowlet<I,O>                                             return _().pure(o);e same input type, and produces one which applies each Arrowlet with the same input.")
  static public function split<I, Oi, Oii>(lhs:Arrowlet<I, Oi>,rhs:Arrowlet<I, Oii>):Arrowlet<I, Couple<Oi,Oii>> {
    return unto(new Split(lhs,rhs));
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  static public function both<Ii,Oi,Iii,Oii>(lhs:Arrowlet<Ii,Oi>,rhs:Arrowlet<Iii,Oii>):Arrowlet<Couple<Ii,Iii>,Couple<Oi,Oii>>{
    return unto(new Both(lhs,rhs));
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  static public function swap<I,Oi,Oii>(self:Arrowlet<I,Couple<Oi,Oii>>):Arrowlet<I,Couple<Oii,Oi>>{
    return self.then((tp:Couple<Oi,Oii>) -> tp.swap());
  }
  @doc("Produces a Couple output of any Arrowlet.")
  static public function fan<I,O>(self:Arrowlet<I,O>):Arrowlet<I,Couple<O,O>>{
    return self.postfix((v) -> __.couple(v,v));
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  static public function joint<I,Oi,Oii>(lhs:Arrowlet<I,Oi>,rhs:Arrowlet<Oi,Oii>):Arrowlet<I,Couple<Oi,Oii>>{
    return lhs.then(Arrowlet.unit().split(rhs));
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  static public function bound<I,Oi,Oii>(lhs:Arrowlet<I,Oi>,rhs:Arrowlet<Couple<I,Oi>,Oii>):Arrowlet<I,Oii>{
    return unto(new Bound(lhs,rhs));
  }
  // @doc("Runs an Arrowlet until it returns Done(out).")
  // static public function repeat<I,O>(a:Arrowlet<I,tink.Either<I,O>>):Repeat<I,O>{
  //   return new Repeat(a);
  // }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<Ii,Iii,O>(lhs:Arrowlet<Ii,O>,rhs:Arrowlet<Iii,O>):Arrowlet<Either<Ii,Iii>,O>{
    return lift(new Or(lhs, rhs).asRecallDef());
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  static public function left<I,Oi,Oii>(self:Arrowlet<I,Oi>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>>{
    return LiftToLeftChoice.toLeftChoice(self);
  }
  //@doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  // static public function amb<A,B>(lhs:Arrowlet<A,B>,rhs:Arrowlet<A,B>):Amb<A,B>{
  //  return new Amb(lhs,rhs);
  //}
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  static public function right<I,Oi,Oii>(self:Arrowlet<I,Oi>):Arrowlet<Either<Oii,I>,Either<Oii,Oi>>{
    return LiftToRightChoice.toRightChoice(self);
  }
  /*
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  static public function fromRight<A,B,C,D>(arr:Arrowlet<B,Either<C,D>>):Arrowlet<Either<C,B>,Either<C,D>>{
    return new RightSwitch(arr);
  }*/
  
  // static public function fromReceiverConstructor<I,O>(fn:I->Receiver<O>):Arrowlet<I,O>{  
  //   return ((i:I,cont:Sink<O>) -> 
  //     Automation.cont(
  //       UIO.fromReceiverThunk(fn.bind(i)),
  //       cont
  //     )
  //   ).broker(
  //     F -> __.arw().cont() 
  //   );
  // }
  static public function prefix<Ii,Iii,O>(self:Arrowlet<Iii,O>,fn:Ii->Iii):Arrowlet<Ii,O>{
    return unto(new Sync(fn)).then(self);
  }
  static public function postfix<I,Oi,Oii>(self:Arrowlet<I,Oi>,fn:Oi->Oii):Arrowlet<I,Oii>{
    return self.then(unto(new Sync(fn)));
  }
  static public function inform<I,Oi,Oii>(lhs:Arrowlet<I,Oi>,rhs:Arrowlet<Oi,Arrowlet<Oi,Oii>>):Arrowlet<I,Oii>{
    return unto(new Inform(lhs,rhs));
  }
  static public function broach<I,O>(self:Arrowlet<I,O>):Arrowlet<I,Couple<I,O>>{
    return bound(self,Arrowlet.fromFun2R(__.couple));
  }
  static public function fulfill<I,O>(self:Arrowlet<I,O>,i:I):Arrowlet<Noise,O>{
    return unto(Recall.Anon(
      (_:Noise,cont) -> self.prepare(i,cont)
    ));
  }
  static public function deliver<I,O>(self:Arrowlet<I,O>,cb:O->Void):Arrowlet<I,Noise>{
    return unto(Recall.Anon(
      (i:I,cont:Sink<Noise>) -> {
        return self.prepare(i,
          (o:O) -> {
            cb(o);
            cont(Noise);
          }
        );
      }
    ));
  }

  static public function prepare<I,O>(self:Arrowlet<I,O>,i:I,cont:Sink<O>):Automation
    return self.applyII(i,cont); 

  static public function flat_map<I,Oi,Oii>(self:Arrowlet<I,Oi>,fn:Oi->Arrowlet<I,Oii>):Arrowlet<I,Oii>{
    return unto(new FlatMap(self,fn));
  }
}