package stx.channel.pack;


@:using(stx.channel.pack.Proceed.ProceedLift)
@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:forward(then) abstract Proceed<O,E>(ProceedDef<O,E>) from ProceedDef<O,E> to ProceedDef<O,E>{
  static public var _(default,never) = ProceedLift;

  public function new(self:ProceedDef<O,E>) this = self;

  @:noUsing static public function lift<O,E>(self:ProceedDef<O,E>):Proceed<O,E> return new Proceed(self);
  @:noUsing static public function unto<O,E>(self:Arrowlet<Noise,Res<O,E>>):Proceed<O,E> return new Proceed(self.asRecallDef());

  @:noUsing static public function pure<O,E>(v:O):Proceed<O,E>{
    return unto(Arrowlet.fromFun1R((_:Noise) -> __.success(v)));
  }
  @:noUsing static public function fromThunkT<O,E>(fn:Void->O):Proceed<O,E>{
    return unto(
      Arrowlet.fromFun1R(
        (_:Noise) -> __.success(fn())
      )
    );
  }
  public function fromIO<O,E>(io:IO<O,E>):Proceed<O,E>{
    return lift(Recall.Anon(
      (_:Noise,cont:Sink<Res<O,E>>) ->  io.applyII(
        Automation.unit(),
        cont
      )
    ));
  }
  private var self(get,never):Proceed<O,E>;
  private function get_self():Proceed<O,E> return this;

  @:to public function toArw():Arrowlet<Noise,Res<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Noise,Res<O,E>>):Proceed<O,E>{
    return lift(self.asRecallDef());
  }
}
class ProceedLift{
  @:noUsing static private function lift<O,E>(self:ProceedDef<O,E>):Proceed<O,E> return Proceed.lift(self);
  
  static public function forward<O,E>(self:Proceed<O,E>):IO<O,E>{
    return IO.fromIODef(
      (auto:Automation, next:Res<O,E>->Void)-> auto.snoc(self.toArw().prepare(Noise,next))
    );
  }  
  static public function postfix<I,O,Z,E>(self:Proceed<O,E>,fn:O->Z):Proceed<Z,E>{
    return lift(self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.map(fn)
      )
    ).asRecallDef());
  }
  static public function errata<O,E,EE>(self:Proceed<O,E>,fn):Proceed<O,EE>{
    return self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.errata(fn)
      )
    );
  }
}