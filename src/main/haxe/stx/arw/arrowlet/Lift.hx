package stx.arw.arrowlet;

using stx.arw.arrowlet.Lift;

import stx.arw.arrowlet.term.*;

class Lift{
  static private inline function lift<I,O,E>(t:ArrowletDef<I,O,E>):Arrowlet<I,O,E>{
    return Arrowlet.lift(t.asArrowletDef());
  }
  static public function inject<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>,v:Oii):Arrowlet<I,Oii,E>{
    return then(self,Arrowlet.fromFun1R((b:Oi) -> v));
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  static public function then<I,Oi,Oii,E>(lhs:ArrowletDef<I,Oi,E>,rhs:Arrowlet<Oi,Oii,E>):Arrowlet<I,Oii,E> {
    return lift(Arrowlet.Then(lhs,rhs));
  }
  static public inline function next<I,Oi,Oii,E>(lhs:ArrowletDef<I,Oi,E>,rhs:Oi->Oii):Arrowlet<I,Oii,E>{
    //__.log().debug(lhs);
    return lhs.toInternal().convention.fold(
      () -> lift(Arrowlet.ThenFun(lhs,rhs)),
      () -> Arrowlet.ThenFunFun(lhs.toInternal().apply,rhs)
    );
  }
  @doc("Takes an ArrowletDef<A,B>, and produces one taking a Couple that runs the Arrowlet on the left-hand side, leaving the right-handside liftuched.")
  static public function first<Ii,Iii,O,E>(self:ArrowletDef<Ii,O,E>):Arrowlet<Couple<Ii,Iii>,Couple<O,Iii>,E>{
    return both(self,Arrowlet.unit());
  }
  @doc("Takes an ArrowletDef<A,B>, and produces one taking a Couple that runs the Arrowlet on the right-hand side, leaving the left-hand side liftuched.")
  static public function second<Ii,O,Iii,E>(self:ArrowletDef<Ii,O,E>):Arrowlet<Couple<Iii,Ii>,Couple<Iii,O>,E>{
    return both(Arrowlet.unit(),self);
  }
  @doc("Takes two Arrowlets with the same input type, and produces one which applies each Arrowlet with the same input.")
  static public function split<I, Oi, Oii,E>(lhs:ArrowletDef<I, Oi,E>,rhs:Arrowlet<I, Oii,E>):Arrowlet<I, Couple<Oi,Oii>,E> {
    return lift(new Split(lhs,rhs));
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  static public function both<Ii,Oi,Iii,Oii,E>(lhs:ArrowletDef<Ii,Oi,E>,rhs:Arrowlet<Iii,Oii,E>):Arrowlet<Couple<Ii,Iii>,Couple<Oi,Oii>,E>{
    return lift(new Both(lhs,rhs));
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  static public function swap<I,Oi,Oii,E>(self:ArrowletDef<I,Couple<Oi,Oii>,E>):Arrowlet<I,Couple<Oii,Oi>,E>{
    return self.then((tp:Couple<Oi,Oii>) -> tp.swap());
  }
  @doc("Produces a Couple output of any Arrowlet.")
  static public function fan<I,O,E>(self:ArrowletDef<I,O,E>):Arrowlet<I,Couple<O,O>,E>{
    return self.postfix((v) -> __.couple(v,v));
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  static public function joint<I,Oi,Oii,E>(lhs:ArrowletDef<I,Oi,E>,rhs:Arrowlet<Oi,Oii,E>):Arrowlet<I,Couple<Oi,Oii>,E>{
    return lhs.then(Arrowlet.unit().split(rhs));
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  static public function bound<I,Oi,Oii,E>(lhs:ArrowletDef<I,Oi,E>,rhs:Arrowlet<Couple<I,Oi>,Oii,E>):Arrowlet<I,Oii,E>{
    return lift(new Bound(lhs,rhs));
  }
  // @doc("Runs an Arrowlet until it returns Done(out).")
  // static public function repeat<I,O>(a:ArrowletDef<I,tink.Either<I,O>>):Repeat<I,O>{
  //   return new Repeat(a);
  // }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<Ii,Iii,O,E>(lhs:ArrowletDef<Ii,O,E>,rhs:Arrowlet<Iii,O,E>):Arrowlet<Either<Ii,Iii>,O,E>{
    return lift(new Or(lhs, rhs).asArrowletDef());
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  static public function left<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>,E>{
    return LiftToLeftChoice.toLeftChoice(self);
  }
  //@doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  // static public function race<A,B>(lhs:ArrowletDef<A,B>,rhs:ArrowletDef<A,B>):Amb<A,B>{
  //  return new Amb(lhs,rhs);
  //}
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  static public function right<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>):Arrowlet<Either<Oii,I>,Either<Oii,Oi>,E>{
    return LiftToRightChoice.toRightChoice(self);
  }
  /*
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  static public function fromRight<A,B,C,D>(arr:ArrowletDef<B,Either<C,D>>):Arrowlet<Either<C,B>,Either<C,D>>{
    return new RightSwitch(arr);
  }*/
  static public function prefix<Ii,Iii,O,E>(self:ArrowletDef<Iii,O,E>,fn:Ii->Iii):Arrowlet<Ii,O,E>{
    return lift(new Sync(fn)).then(self);
  }
  static public function postfix<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>,fn:Oi->Oii):Arrowlet<I,Oii,E>{
    return self.next(fn);
  }
  /**
    * Asynchronous version of `FlatMap`
  **/
  static public function inform<I,Oi,Oii,E>(lhs:ArrowletDef<I,Oi,E>,rhs:Arrowlet<Oi,Arrowlet<Oi,Oii,E>,E>):Arrowlet<I,Oii,E>{
    return lift(new Inform(lhs,rhs));
  }
  static public function broach<I,O,E>(self:ArrowletDef<I,O,E>):Arrowlet<I,Couple<I,O>,E>{
    return new stx.arw.arrowlet.term.Broach(self);
  }
  static public function state<I,O,E>(self:ArrowletDef<I,O,E>):Arrowlet<I,Couple<O,I>,E>{
    return bound(self,Arrowlet.fromFun2R(__.couple.fn().then(tp -> tp.swap())));
  }
  /*
  static public function contain<I,O,E>(self:ArrowletDef<I,O,E>):Attempt<I,O,E>{
    return lift(Arrowlet.Anon(
      (_:I,cont:Terminal<Res<O,E>,Defect>) -> {
        self.
      }
    ));
  }*/
  static public function fulfill<I,O,E>(self:ArrowletDef<I,O,E>,i:I):Arrowlet<Noise,O,E>{
    return lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<O,E>) -> self.prepare(i,cont)
    ));
  }
  static public function deliver<I,O,E>(self:ArrowletDef<I,O,E>,cb:O->Void):Arrowlet<I,Noise,E>{
    return Arrowlet.Then(
      self,
      Arrowlet.Sync((o) -> {
        cb(o);
        return Noise;
      })
    );
  }
  static public inline function prepare<I,O,E>(self:ArrowletDef<I,O,E>,i:I,cont:Terminal<O,E>):Work{
    return self.toInternal().convention.fold(
      () -> self.toInternal().defer(i,cont),
      () -> cont.value(self.toInternal().apply(i)).serve()
    );
  }
  @:noUsing static public inline function environment<I,O,E>(self:ArrowletDef<I,O,E>,i:I,success:O->Void,failure:Defect<E>->Void):Fiber{
    return Fiber.lift(Arrowlet.Deliver(Arrowlet.Fulfill(self,i),success,failure));
  }

  static public inline function fudge<I,O,E>(self:ArrowletDef<I,O,E>,i:I):O{
    var v = null;
    function fn(x){v = x;}
    environment(self,i,fn,__.crack).crunch();
    //trace('fudge: $v');
    return v;
  }
  static public function flat_map<I,Oi,Oii,E>(self:ArrowletDef<I,Oi,E>,fn:Oi->Arrowlet<I,Oii,E>):Arrowlet<I,Oii,E>{
    return lift(new FlatMap(self,fn));
  }
  static public function pinch<I,O1,O2,E>(a:ArrowletDef<Couple<I,I>,Couple<O1,O2>,E>):Arrowlet<I,Couple<O1,O2>,E>{
    return then(fan(Arrowlet.unit()),a);
  }
  static public inline function toInternal<I,O,E>(self:ArrowletDef<I,O,E>){
    return Arrowlet.lift(self).toInternal();
  }
  public inline function contextualize<I,O,E>(self:Arrowlet<I,O,E>,i:I,?success:O->Void,?failure:Defect<E>->Void):Fiber{
    return Contextualize.make(i,success,failure).load(self);
  }
}