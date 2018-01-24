package stx.arrowlet.core.body;

class Arrowlets{
  /*
  static public function later<A,B>(arw:Arrowlet<A,B>,v:A):Arrowlet<Noise,B>{
    return function(n:Noise,cont:Sink<B>){
      return arw(Fly(v,cont));
    }
  }
  static public function inject<A,B,C>(arw:Arrowlet<A,B>,v:C):Arrowlet<A,C>{
    return arw.then(
      (b:B) -> v
    );
  }*/
  static public inline function tap<I,O>(arw:Arrowlet<I,O>,fn:O->Void){
    return then(arw,
      Lift.fromSink(function(i,cont){
        fn(i);
        cont(i);
      }
    ));
  }
  @doc("Arrowlet application primitive. Calls Arrowlet with `i` and places result in `cont`.")
  static public inline function withInput<I,O>(arw:Arrowlet<I,O>,i:I,cont:Sink<O>):Block{
    return arw.withInput(i,cont);
  }
  static public inline function apply<I,O>(arw:Arrowlet<I,O>,i:I):Future<O>{
    var trg       = new FutureTrigger();

    withInput(arw,i,
      function(x:O){
        trg.trigger(x);
      }
    );
    return trg.asFuture();
  }
  static public inline function runWith<I,O>(arw:Arrowlet<I,O>,i:I):Future<O>{
    return apply(arw,i);
  }
  @doc("left to right composition of Arrowlets. Produces an Arrowlet running `before` and placing it's value in `after`.")
  static public function then<A,B,C>(before:Arrowlet<A,B>, after:Arrowlet<B,C>):Arrowlet<A,C> {
    return new Then(before,after);
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the left-hand side, leaving the right-handside untouched.")
  static public function first<A,B,C>(first:Arrowlet<A,B>):Arrowlet<Tuple2<A,C>,Tuple2<B,C>>{
    return pair(first, Arrowlet.unit());
  }
  @doc("Takes an Arrowlet<A,B>, and produces one taking a Tuple2 that runs the Arrowlet on the right-hand side, leaving the left-hand side untouched.")
  static public function second<A,B,C>(second:Arrowlet<A,B>):Arrowlet<Tuple2<C,A>,Tuple2<C,B>>{
    return pair(Arrowlet.unit(), second);
  }
  @doc("Takes two Arrowlets with the same input type, and produces one which applies each Arrowlet with thesame input.")
  static public function split<A, B, C>(split_:Arrowlet<A, B>, _split:Arrowlet<A, C>):Arrowlet<A, Tuple2<B,C>> {
    return function(i:A, cont:Sink<Tuple2<B,C>>) : Block{
      return withInput(pair(split_,_split),tuple2(i,i) , cont);
    };
  }
  @doc("Takes two Arrowlets and produces on that runs them in parallel, waiting for both responses before output.")
  static public function pair<A,B,C,D>(pair_:Arrowlet<A,B>,_pair:Arrowlet<C,D>):Both<A,B,C,D>{
    return new Both(pair_,_pair);
  }
  @doc("Changes <B,C> to <C,B> on the output of an Arrowlet")
  static public function swap<A,B,C>(a:Arrowlet<A,Tuple2<B,C>>):Arrowlet<A,Tuple2<C,B>>{
    return a.then(Tuples2.swap);
  }
  @doc("Produces a Tuple2 output of any Arrowlet.")
  static public function fan<I,O>(a:Arrowlet<I,O>):Arrowlet<I,Tuple2<O,O>>{
    return a.then(
      (v) -> tuple2(v,v)
    );
  }
  @doc("Pinches the input stage of an Arrowlet. `<I,I>` as `<I>`")
  static public function pinch<I,O1,O2>(a:Arrowlet<Tuple2<I,I>,Tuple2<O1,O2>>):Arrowlet<I,Tuple2<O1,O2>>{
    return then(fan(Arrowlet.unit()),a);
  }
  @doc("Produces an Arrowlet that runs the same Arrowlet on both sides of a Tuple2")
  static public function both<A,B>(a:Arrowlet<A,B>):Arrowlet<Tuple2<A,A>,Tuple2<B,B>>{
    return pair(a,a);
  }
  @doc("Casts the output of an Arrowlet to `type`.")
  static public function as<A,B,C>(a:Arrowlet<A,B>,type:Class<C>):Arrowlet<A,C>{
    return a.then(
      (b:B) -> cast b
    );
  }
  @doc("Runs the first Arrowlet, then the second, preserving the output of the first on the left-hand side.")
  static public function join<A,B,C>(joinl:Arrowlet<A,B>,joinr:Arrowlet<B,C>):Arrowlet<A,Tuple2<B,C>>{
    return joinl.then(
      Arrowlet.unit().split(joinr)
    );
  }
  @doc("Runs the first Arrowlet and places the input of that Arrowlet and the output in the second Arrowlet.")
  static public function bind<A,B,C>(bindl:Arrowlet<A,B>,bindr:Arrowlet<Tuple2<A,B>,C>):Arrowlet<A,C>{
    return Arrowlet.unit().split(bindl).then(bindr);
  }
  @doc("Runs an Arrowlet until it returns Done(out).")
  static public function repeat<I,O>(a:Arrowlet<I,tink.Either<I,O>>):Repeat<I,O>{
    return new Repeat(a);
  }
  @doc("Produces an Arrowlet that will run `or_` if the input is Left(in), or '_or' if the input is Right(in);")
  static public function or<P1,P2,R0>(or_:Arrowlet<P1,R0>,_or:Arrowlet<P2,R0>):Or<P1,P2,R0>{
    return new Or(or_, _or);
  }
  @doc("Produces an Arrowlet that will run only if the input is Left.")
  public static function left<B,C,D>(arr:Arrowlet<B,C>):LeftChoice<B,C,D>{
    return new LeftChoice(arr);
  }
  @doc("Produces an Arrowlet that returns a value from the first completing Arrowlet.")
  public static function amb<A,B>(a:Arrowlet<A,B>,b:Arrowlet<A,B>):Amb<A,B>{
    return new Amb(a,b);
  }
  @doc("Produces an Arrowlet that will run only if the input is Right.")
  public static function right<B,C,D>(arr:Arrowlet<B,C>):Arrowlet<Either<D,B>,Either<D,C>>{
    return new RightChoice(arr);
  }
  /*
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Right.")
  public static function fromRight<A,B,C,D>(arr:Arrowlet<B,Either<C,D>>):Arrowlet<Either<C,B>,Either<C,D>>{
    return new RightSwitch(arr);
  }*/
  @doc("Takes an Arrowlet that produces an Either, and produces one that will run that Arrowlet if the input is Left.")
  public static function fromLeft<A,B,C,D>(arr:Arrowlet<A,Either<C,D>>):Arrowlet<Either<A,D>,Either<C,D>>{
    return then(new LeftChoice(arr),
      function(e){
        return switch(e){
          case Left(Left(l))  : Left(l);
          case Left(Right(r)) : Right(r);
          case Right(r) : Right(r);
        }
      }
    );
  }
  @doc("Produces an Arrowlet that patches the output with `n`.")
  public static function exchange<I,O,N>(a:Arrowlet<I,O>,n:N):Arrowlet<I,N>{
    return then(a,
      function(x:O):N{
        return n;
      }
    );
  }
  /*
  @doc("Flattens the output of an Arrowlet where it is Option<Option<O>> ")
  static public function flatten<I,O>(arw:Arrowlet<Option<I>,Option<Option<O>>>):Arrowlet<Option<I>,Option<O>>{
    return arw.then(
      (i:Option<Option<I>>) -> switch(i){
          case Some(Some(v))  : Some(v);
          default             : None;
      }
    );
  }*/
  @doc("Runs a `then` operation where the creation of the second arrow requires a function call to produce it.")
  static public function invoke<A,B,C>(a:Arrowlet<A,B>,b:Thunk<Arrowlet<B,C>>){
    return then(a,
      function(x:B){
        var n = b();
        return tuple2(n,x);
      }
    );
  }
  @:noUsing static public function state<S,A>(a:Arrowlet<S,Tuple2<A,S>>):State<S,A>{
    return new State(a);
  }
  @doc("Returns an ApplyArrowlet.")
  @:noUsing static public function application<I,O>():Apply<I,O>{
    return new Apply();
  }
  #if (flash || js )
  static public function delay<A>(ms:Int):Arrowlet<A,A>{
    var out = function(i:A,cont:Sink<A>){
    haxe.Timer.delay(
        function(){
          cont(i);
        },ms);
      return () -> {}
    }
    return out;
  }
  #end
}