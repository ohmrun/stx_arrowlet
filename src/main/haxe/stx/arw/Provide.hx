package stx.arw;

typedef ProvideDef<O> = ConvertDef<Noise,O>;
@:using(stx.arw.Provide.ProvideLift)
@:using(stx.arw.arrowlet.Lift)
abstract Provide<O>(ProvideDef<O>) from ProvideDef<O> to ProvideDef<O>{
  static public var _(default,never) = ProvideLift;
  public inline function new(self) this = self;
  static public inline function lift<O>(self:ProvideDef<O>):Provide<O> return new Provide(self);

  // @:from static public inline function fromFunTerminalWork<O>(fn:Terminal<O,Noise>->Work):Provide<O>{
  //   return lift(
  //     Arrowlet.Anon(
  //       (i:Noise,cont:Terminal<O,Noise>) -> fn(cont)
  //     )
  //   );
  // }
  @:noUsing static public inline function pure<O>(v:O):Provide<O>{
    return lift(new stx.arw.provide.term.Sync(v));
  }
  @:noUsing static public inline function fromFuture<O>(future:Future<O>):Provide<O>{
    return lift(new stx.arw.provide.term.Later(future));
  }
  @:from static public inline function fromFunXR<O>(fn:Void->O):Provide<O>{
    return lift(new stx.arw.provide.term.Thunk(fn));
  }
  @:from static public inline function fromFunXFuture<O>(fn:Void->Future<O>):Provide<O>{
    return lift(new stx.arw.provide.term.FunXFutureProvide(fn));
  }
  @:noUsing static public inline function fromFunTerminalWork<O>(fn):Provide<O>{
    return lift(new stx.arw.provide.term.ProvideFunTerminalWork(fn));
  }
  @:from static public inline function fromFunFuture<O>(ft:Future<O>):Provide<O>{
    return lift(
      Arrowlet.Anon(
        (i:Noise,cont:Terminal<O,Noise>) -> {
          return cont.later(ft.map(Success)).serve();
        }
      )
    );
  }
  static public inline function bind_fold<T,O>(fn:Convert<Couple<T,O>,O>,arr:Array<T>,seed:O):Provide<O>{
    return arr.lfold(
      (next:T,memo:Provide<O>) -> {
        return memo.convert(
          Convert.fromConvertProvide(
            (o) -> fn.provide(__.couple(next,o))
          )
        );
      },
      Provide.pure(seed)
    );
  }
  @:to public inline function toArrowlet():Arrowlet<Noise,O,Noise>{
    return this;
  }
  public function prj():ProvideDef<O> return this;
  private var self(get,never):Provide<O>;
  private function get_self():Provide<O> return lift(this);

  public inline function fudge(){
    return _.fudge(this);
  }
}

class ProvideLift{
  static public inline function environment<O>(self:Provide<O>,handler:O->Void):Fiber{
    return Arrowlet._.environment(
      self,
      Noise,
      (o) -> {
        handler(o);
      },
      (e) -> throw(e)
    );
  }
  static public function flat_map<O,Oi>(self:Provide<O>,fn:O->ProvideDef<Oi>):Provide<Oi>{
    return Provide.lift(Arrowlet.FlatMap(self.toArrowlet(),fn));
  }
  static public function and<Oi,Oii>(lhs:ProvideDef<Oi>,rhs:ProvideDef<Oii>):Provide<Couple<Oi,Oii>>{
    return Provide.lift(Arrowlet._.pinch(
      Arrowlet._.both(
        lhs,
        rhs
      )
    ));
  }
  static public function convert<O,Oi>(self:ProvideDef<O>,that:Convert<O,Oi>):Provide<Oi>{
    return Provide.lift(Convert._.then(
      self,
      that
    ));
  }
  static public inline function prepare<O>(self:ProvideDef<O>,cont:Terminal<O,Noise>):Work{
    return Arrowlet._.prepare(self,Noise,cont);
  }
  static public function toProduce<O,E>(self:ProvideDef<O>):Produce<O,E>{
    return Produce.lift(Arrowlet.Then(self,Arrowlet.Sync(__.accept)));
  }
  static public function attempt<O,Oi,E>(self:Provide<O>,that:Attempt<O,Oi,E>):Produce<Oi,E>{
    return toProduce(self).attempt(that);
  }
  static public function postfix<O,Oi>(self:ProvideDef<O>,fn:O->Oi):Provide<Oi>{
    return Provide.lift(
      Arrowlet.Then(
        self,
        Arrowlet.Sync(fn)
      )
    );
  }
  static public inline function fudge<O>(self:Provide<O>):O{
    return Arrowlet._.fudge(self,Noise);
  }
  static public inline function contextualize<O>(self:Provide<O>,?success:O->Void,?failure:Defect<Noise>->Void):Fiber{
    return Contextualize.make(Noise,success,failure).load(self.toArrowlet().asArrowletDef());
  }
  
}