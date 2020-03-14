package stx.arrowlet.core.pack.arrowlet;

class Destructure extends Clazz{
  
  public inline function unto<I,O>(t:RecallDef<I,O,Automation>):Arrowlet<I,O>{
    return lift(t.asRecallDef());
  }
  private inline function lift<I,O>(def:ArrowletDef<I,O>):Arrowlet<I,O>{
    return lift(def);
  }
  public function inject<I,Oi,Oii>(v:Oii,self:Arrowlet<I,Oi>):Arrowlet<I,Oii>{
    return self.then((b:Oi) -> v);
  }
  public function receive<I,O>(i:I,self:Arrowlet<I,O>):Receiver<O>{
    return Receiver.inj().into(self.prepare.bind(i));
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  public function then<I,Oi,Oii>(rhs:Arrowlet<Oi,Oii>,lhs:Arrowlet<I,Oi>):Arrowlet<I,Oii> {
    return unto(new Then(lhs,rhs));
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  public function first<Ii,Iii,O>(self:Arrowlet<Ii,O>):Arrowlet<Tuple2<Ii,Iii>,Tuple2<O,Iii>>{
    return both(Arrowlet.unit(),self);
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  public function second<Ii,O,Iii>(self:Arrowlet<Ii,O>):Arrowlet<Tuple2<Iii,Ii>,Tuple2<Iii,O>>{
    return both(self,Arrowlet.unit());
  }
  @doc("Takes two Arrowlets with thstatic public function pure<I,O>(o:O):Arrowlet<I,O>                                             return _().pure(o);e same input type, and produces one which applies each Arrowlet with the same input.")
  public function split<I, Oi, Oii>(rhs:Arrowlet<I, Oii>,lhs:Arrowlet<I, Oi>):Arrowlet<I, Tuple2<Oi,Oii>> {
    return unto(new Split(lhs,rhs));
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  public function both<Ii,Oi,Iii,Oii>(rhs:Arrowlet<Iii,Oii>,lhs:Arrowlet<Ii,Oi>):Arrowlet<Tuple2<Ii,Iii>,Tuple2<Oi,Oii>>{
    return unto(new Both(lhs,rhs));
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  public function swap<I,Oi,Oii>(self:Arrowlet<I,Tuple2<Oi,Oii>>):Arrowlet<I,Tuple2<Oii,Oi>>{
    return self.then((tp:Tuple2<Oi,Oii>) -> tp.swap());
  }
  @doc("Produces a Tuple2 output of any Arrowlet.")
  public function fan<I,O>(self:Arrowlet<I,O>):Arrowlet<I,Tuple2<O,O>>{
    return self.postfix((v) -> tuple2(v,v));
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  public function joint<I,Oi,Oii>(rhs:Arrowlet<Oi,Oii>,lhs:Arrowlet<I,Oi>):Arrowlet<I,Tuple2<Oi,Oii>>{
    return lhs.then(Arrowlet.unit().split(rhs));
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  public function bound<I,Oi,Oii>(rhs:Arrowlet<Tuple2<I,Oi>,Oii>,lhs:Arrowlet<I,Oi>):Arrowlet<I,Oii>{
    return unto(new Bound(lhs,rhs));
  }
  // @doc("Runs an Arrowlet until it returns Done(out).")
  // public function repeat<I,O>(a:Arrowlet<I,tink.Either<I,O>>):Repeat<I,O>{
  //   return new Repeat(a);
  // }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  public function or<Ii,Iii,O>(rhs:Arrowlet<Iii,O>,lhs:Arrowlet<Ii,O>):Arrowlet<Either<Ii,Iii>,O>{
    return lift(new Or(lhs, rhs).asRecallDef());
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  public function left<I,Oi,Oii>(self:Arrowlet<I,Oi>):Arrowlet<Either<I,Oii>,Either<Oi,Oii>>{
    return LiftToLeftChoice.toLeftChoice(self);
  }
  //@doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  // public function amb<A,B>(lhs:Arrowlet<A,B>,rhs:Arrowlet<A,B>):Amb<A,B>{
  //  return new Amb(lhs,rhs);
  //}
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  public function right<I,Oi,Oii>(self:Arrowlet<I,Oi>):Arrowlet<Either<Oii,I>,Either<Oii,Oi>>{
    return LiftToRightChoice.toRightChoice(self);
  }
  /*
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  public function fromRight<A,B,C,D>(arr:Arrowlet<B,Either<C,D>>):Arrowlet<Either<C,B>,Either<C,D>>{
    return new RightSwitch(arr);
  }*/
  
  // public function fromReceiverConstructor<I,O>(fn:I->Receiver<O>):Arrowlet<I,O>{  
  //   return ((i:I,cont:Sink<O>) -> 
  //     Automation.cont(
  //       UIO.fromReceiverThunk(fn.bind(i)),
  //       cont
  //     )
  //   ).broker(
  //     F -> __.arw().cont() 
  //   );
  // }
  public function prefix<Ii,Iii,O>(fn:Ii->Iii,self:Arrowlet<Iii,O>):Arrowlet<Ii,O>{
    return unto(new Sync(fn)).then(self);
  }
  public function postfix<I,Oi,Oii>(fn:Oi->Oii,self:Arrowlet<I,Oi>):Arrowlet<I,Oii>{
    return self.then(unto(new Sync(fn)));
  }
  public function inform<I,Oi,Oii>(rhs:Arrowlet<Oi,Arrowlet<Oi,Oii>>,lhs:Arrowlet<I,Oi>):Arrowlet<I,Oii>{
    return unto(new Inform(lhs,rhs));
  }
  public function broach<I,O>(self:Arrowlet<I,O>):Arrowlet<I,Tuple2<I,O>>{
    return bound(tuple2,self);
  }
  public function fulfill<I,O>(i:I,self:Arrowlet<I,O>):Arrowlet<Noise,O>{
    return unto(Recall.Anon(
      (_:Noise,cont) -> self.prepare(i,cont)
    ));
  }
  public function deliver<I,O>(cb:O->Void,self:Arrowlet<I,O>):Arrowlet<I,Noise>{
    return unto(Recall.Anon(
      (i:I,cont:Sink<Noise>) -> {
        return self.prepare(i,
          (o:O) -> {
            cb(o);
            cont(Noise);
            return Automation.unit();
          }
        );
      }
    ));
  }

  public function prepare<I,O>(i:I,cont:Sink<O>,self:Arrowlet<I,O>):Automation
    return self.duoply(i,cont); 

  public function flat_map<I,Oi,Oii>(fn:Oi->Arrowlet<I,Oii>,self:Arrowlet<I,Oi>):Arrowlet<I,Oii>{
    return unto(new FlatMap(self,fn));
  }
}