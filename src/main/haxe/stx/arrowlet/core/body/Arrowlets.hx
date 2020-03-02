package stx.arrowlet.core.body;
 
class Arrowlets extends Clazz{
  public function inject<A,B,C>(arw:Arrowlet<A,B>,v:C):Arrowlet<A,C>{
    return arw.then(
      (b:B) -> v
    );
  }
  public function tapO<I,O>(arw:Arrowlet<I,O>,fn:O->Void):Arrowlet<I,O>{
    return then(arw,__.arw().fn()(__.command(fn)));
  }
  public function receive<I,O>(arw:Arrowlet<I,O>,i:I):Receiver<O>{
    return Receiver.lift(
      (next) -> arw.prepare(
          i, 
          Sink.lift(
            (o,auto) -> {
              next(o);
              return auto;
            }
          )
        )
    );
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  public function then<A,B,C>(before:Arrowlet<A,B>, after:Arrowlet<B,C>):Arrowlet<A,C> {
    return new Then(before,after);
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  public function first<A,B,C>(first:Arrowlet<A,B>):Arrowlet<Tuple2<A,C>,Tuple2<B,C>>{
    return both(first, Arrowlet.unit());
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  public function second<A,B,C>(second:Arrowlet<A,B>):Arrowlet<Tuple2<C,A>,Tuple2<C,B>>{
    return both(Arrowlet.unit(), second);
  }
  @doc("Takes two Arrowlets with the same input type, and produces one which applies each Arrowlet with the same input.")
  public function split<A, B, C>(split_:Arrowlet<A, B>, _split:Arrowlet<A, C>):Arrowlet<A, Tuple2<B,C>> {
    return fan(Arrowlet.unit()).then(both(split_,_split));
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  public function both<A,B,C,D>(pair_:Arrowlet<A,B>,_pair:Arrowlet<C,D>):Both<A,B,C,D>{
    return new Both(pair_,_pair);
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  public function swap<A,B,C>(a:Arrowlet<A,Tuple2<B,C>>):Arrowlet<A,Tuple2<C,B>>{
    return a.then((tp:Tuple2<B,C>) -> tp.swap());
  }
  @doc("Produces a Tuple2 output of any Arrowlet.")
  public function fan<I,O>(a:Arrowlet<I,O>):Arrowlet<I,Tuple2<O,O>>{
    return a.postfix((v) -> tuple2(v,v));
  }
  @doc("Casts the output of an Arrowlet to `type`.")
  public function as<A,B,C>(a:Arrowlet<A,B>,type:Class<C>):Arrowlet<A,C>{
    return a.then(
      (b:B) -> cast b
    );
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  public function joint<A,B,C>(jointl:Arrowlet<A,B>,jointr:Arrowlet<B,C>):Arrowlet<A,Tuple2<B,C>>{
    return jointl.then(
      Arrowlet.unit().split(jointr)
    );
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  public function bound<A,B,C>(boundl:Arrowlet<A,B>,boundr:Arrowlet<Tuple2<A,B>,C>):Arrowlet<A,C>{
    return Arrowlet.unit().split(boundl).then(boundr);
  }
  // @doc("Runs an Arrowlet until it returns Done(out).")
  // public function repeat<I,O>(a:Arrowlet<I,tink.Either<I,O>>):Repeat<I,O>{
  //   return new Repeat(a);
  // }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  public function or<P1,P2,R0>(or_:Arrowlet<P1,R0>,_or:Arrowlet<P2,R0>):Or<P1,P2,R0>{
    return new Or(or_, _or);
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  public function left<B,C,D>(arr:Arrowlet<B,C>):LeftChoice<B,C,D>{
    return new LeftChoice(arr);
  }
  @doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  public function amb<A,B>(a:Arrowlet<A,B>,b:Arrowlet<A,B>):Amb<A,B>{
    return new Amb(a,b);
  }
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  public function right<B,C,D>(arr:Arrowlet<B,C>):Arrowlet<Either<D,B>,Either<D,C>>{
    return new RightChoice(arr);
  }
  /*
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  public function fromRight<A,B,C,D>(arr:Arrowlet<B,Either<C,D>>):Arrowlet<Either<C,B>,Either<C,D>>{
    return new RightSwitch(arr);
  }*/
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Left.")
  public function fromLeft<A,B,C,D>(arr:Arrowlet<A,Either<C,D>>):Arrowlet<Either<A,D>,Either<C,D>>{
    return postfix(new LeftChoice(arr),
      function(e){
        return switch(e){
          case Left(Left(l))    : Left(l);
          case Left(Right(r))   : Right(r);
          case Right(r)         : Right(r);
        }
      }
    );
  }
  @doc("Produces an Arrowlet that patches the output with `n`.")
  public function exchange<I,O,N>(a:Arrowlet<I,O>,n:N):Arrowlet<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  @doc("Flattens the output of an Arrowlet where it is Option<Option<O>> ")
  public function flatten<I,O>(arw:Arrowlet<Option<I>,Option<Option<O>>>):Arrowlet<Option<I>,Option<O>>{
    var fold = Options._.fold.bind(
      (v:Option<O>)         -> v,
      ()                    -> None
    ).broker(
      (F) -> F.then(__.arw().fn())
    );
    return arw.then(fold);
  }
  
  #if (flash || js )
  public function delay<A>(ms:Int):Arrowlet<A,A>{
    var out = function(i:A,cont:Sink<A>){
      haxe.Timer.delay(
        function(){
          cont(i,Automation.unit()).submit();
        },ms);
      return Automation.unit();
    }
    return __.arw().cont()(out);
  }
  #end
  // @:noUsing public function fromReceiverConstructor<I,O>(fn:I->Receiver<O>):Arrowlet<I,O>{  
  //   return ((i:I,cont:Sink<O>) -> 
  //     Automation.cont(
  //       UIO.fromReceiverThunk(fn.bind(i)),
  //       cont
  //     )
  //   ).broker(
  //     F -> __.arw().cont() 
  //   );
  // }
  @:noUsing public function prefix<I,O,P>(arw:Arrowlet<I,O>,fn:P->I):Arrowlet<P,O>{
    return __.arw().fn()(fn).then(arw);
  }
  @:noUsing public function postfix<I,O,R>(arw:Arrowlet<I,O>,fn:O->R):Arrowlet<I,R>{
    return arw.then(__.arw().fn()(fn));
  }
  @:noUsing public function choose<I,O,R>(arw0:Arrowlet<I,O>,arw1:Arrowlet<O,Arrowlet<O,R>>):Arrowlet<I,R>{
    return arw0.then(
      arw1.broach().postfix((tp)->tp.swap()).then(__.arw().apply())
    );
  }
  @:noUsing public function fulfill<I,O>(arw:Arrowlet<I,O>,i:I):Arrowlet<Noise,O>{
    return __.arw().cont()(
      (_:Noise,cont:Sink<O>) -> arw.prepare(i,cont)
    );
  }
  @:noUsing public function deliver<I,O>(arw:Arrowlet<I,O>,cb:O->Void):Arrowlet<I,Noise>{
    return __.arw().cont()(
      (i:I,cont:Sink<Noise>) -> {
        return arw.prepare(
          i,
          (o:O,auto:Automation) -> {
            cb(o);
            return cont(Noise,auto);
          }
        );
      }
    );
  }
}