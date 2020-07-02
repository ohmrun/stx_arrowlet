package stx.arrowlet.pack;

typedef ForwardDef<O> = ProcessDef<Noise,O>;

@:using(stx.arrowlet.pack.Forward.ForwardLift)
abstract Forward<O>(ForwardDef<O>) from ForwardDef<O> to ForwardDef<O>{
  static public var _(default,never) = ForwardLift;
  public function new(self) this = self;
  static public function lift<O>(self:ForwardDef<O>):Forward<O> return new Forward(self);

  @:from static public function fromFunTerminalWork<O>(fn:Terminal<O,Noise>->Work):Forward<O>{
    return lift(
      Arrowlet.Anon(
        (i:Noise,cont:Terminal<O,Noise>) -> fn(cont)
      )
    );
  }
  @:noUsing static public function pure<O>(v:O):Forward<O>{
    return lift(Arrowlet.pure(v));
  }
  @:from static public function fromFunXR<O>(fn:Void->O):Forward<O>{
    return lift(
      Arrowlet.Anon(
        (i:Noise,cont:Terminal<O,Noise>) -> {
          return cont.value(fn()).serve();
        }
      )
    );
  }
  @:from static public function fromFunXFuture<O>(fn:Void->Future<O>):Forward<O>{
    return lift(
      Arrowlet.Anon(
        (i:Noise,cont:Terminal<O,Noise>) -> {
          var defer = Future.trigger();
          fn().map(Success).handle(defer.trigger);
          return cont.defer(defer).serve();
        }
      )
    );
  }
  public function environment(handler:O->Void):Thread{
    return Arrowlet._.environment(
      this,
      Noise,
      (o) -> {
        handler(o);
      },
      (e) -> throw(e)
    );
  }
  static public function bind_fold<T,O>(fn:Process<Couple<T,O>,O>,arr:Array<T>,seed:O):Forward<O>{
    return arr.lfold(
      (next:T,memo:Forward<O>) -> {
        return memo.process(
          Process.fromProcessForward(
            (o) -> fn.forward(__.couple(next,o))
          )
        );
      },
      Forward.pure(seed)
    );
  }
  @:to public function toArrowlet():Arrowlet<Noise,O,Noise>{
    return this;
  }
  public function prj():ForwardDef<O> return this;
  private var self(get,never):Forward<O>;
  private function get_self():Forward<O> return lift(this);
}

class ForwardLift{
  static public function flat_map<O,Oi>(self:Forward<O>,fn:O->ForwardDef<Oi>):Forward<Oi>{
    return Forward.lift(Arrowlet.FlatMap(self.toArrowlet(),fn));
  }
  static public function and<Oi,Oii>(lhs:ForwardDef<Oi>,rhs:ForwardDef<Oii>):Forward<Couple<Oi,Oii>>{
    return Forward.lift(Arrowlet._.pinch(
      Arrowlet._.both(
        lhs,
        rhs
      )
    ));
  }
  static public function process<O,Oi>(self:ForwardDef<O>,that:Process<O,Oi>):Forward<Oi>{
    return Forward.lift(Process._.then(
      self,
      that
    ));
  }
  static public function prepare<O>(self:ForwardDef<O>,cont:Terminal<O,Noise>):Work{
    return Arrowlet._.prepare(self,Noise,cont);
  }
  static public inline function fudge<O>(self:Forward<O>):O{
    var v = null;
    self.environment(
      (o) -> v = o
    ).crunch();
    return v;
  }
  static public function toProceed<O,E>(self:ForwardDef<O>):Proceed<O,E>{
    return Proceed.lift(Arrowlet.Then(self,Arrowlet.Sync(__.success)));
  }
  static public function attempt<O,Oi,E>(self:Forward<O>,that:Attempt<O,Oi,E>):Proceed<Oi,E>{
    return toProceed(self).attempt(that);
  }
}