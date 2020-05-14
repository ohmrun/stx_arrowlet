package stx.arrowlet.pack;

typedef ProceedDef<O,E> = ArrowletDef<Noise,Res<O,E>,Noise>;

@:using(stx.arrowlet.pack.Proceed.ProceedLift)
@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:forward(then) abstract Proceed<O,E>(ProceedDef<O,E>) from ProceedDef<O,E> to ProceedDef<O,E>{
  static public var _(default,never) = ProceedLift;

  public function new(self:ProceedDef<O,E>) this = self;

  @:noUsing static public function lift<O,E>(self:ProceedDef<O,E>):Proceed<O,E> return new Proceed(self);

  @:noUsing static public function pure<O,E>(v:O):Proceed<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> __.success(v)));
  }
  @:noUsing static public function fromRes<O,E>(res:Res<O,E>):Proceed<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> res));
  }
  @:from @:noUsing static public function fromFunXRes<O,E>(fn:Void->Res<O,E>):Proceed<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> fn()));
  }
  @:noUsing static public function fromFunXR<O,E>(fn:Void->O):Proceed<O,E>{
    return lift(
      Arrowlet.fromFun1R(
        (_:Noise) -> __.success(fn())
      )
    );
  }
  @:noUsing static public function fromArrowlet<O,E>(arw:Arrowlet<Noise,O,E>):Proceed<O,E>{
    return lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<Res<O,E>,Noise>) ->  {
        var defer = Future.trigger();
        var inner = cont.inner(
              (outcome:Outcome<O,E>) -> {
                //trace("INNER");
                defer.trigger(Success(
                  outcome.fold(
                    __.success,
                    (e) -> __.failure(__.fault().of(e))
                  )
                ));
              }
            );
        return cont.defer(defer).after(arw.prepare(Noise,inner)); 
      })
    );
  }
  @:to public function toArrowlet():Arrowlet<Noise,Res<O,E>,Noise>{
    return this;
  }
  private var self(get,never):Proceed<O,E>;
  private function get_self():Proceed<O,E> return this;

}
class ProceedLift{
  @:noUsing static private function lift<O,E>(self:ProceedDef<O,E>):Proceed<O,E> return Proceed.lift(self);
  
  static public function postfix<I,O,Z,E>(self:Proceed<O,E>,fn:O->Z):Proceed<Z,E>{
    return lift(self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.map(fn)
      )
    ));
  }
  static public function errata<O,E,EE>(self:Proceed<O,E>,fn):Proceed<O,EE>{
    return lift(self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.errata(fn)
      )
    ));
  }
  static public function environment<O,E>(self:Proceed<O,E>,success:O->Void,failure:Err<E>->Void):Thread{
    return Arrowlet._.environment(
      self,
      Noise,
      (res:Res<O,E>) -> {
        res.fold(success,failure);
      },
      (_) -> {}
    );
  }
  static public function point<O,E>(self:Proceed<O,E>,success:O->Execute<E>):Execute<E>{
    return Execute.lift(
      Arrowlet.Anon(
        (_:Noise,cont:Terminal<Report<E>,Noise>) -> {
          var defer   = Future.trigger();
          var inner   = cont.inner(
            (outcome:Outcome<Res<O,E>,Noise>) -> {
              switch(outcome){
                case Success(Success(o)) : 
                  defer.trigger(success(o).prepare(cont));
                case Success(Failure(e)) : 
                  defer.trigger(cont.value(Report.pure(e)).serve());
                default :
                  defer.trigger(cont.error(Noise).serve());
              }
              null;
            }
          );
          return self.prepare(inner).seq(cont.waits(defer));
        } 
      )
    );
  }
  static public function process<O,Oi,E>(self:Proceed<O,E>,then:Process<O,Oi>):Proceed<Oi,E>{
    return lift(Arrowlet.Then(self,then.toCascade()));
  }
  static public function prepare<O,E>(self:Proceed<O,E>,cont:Terminal<Res<O,E>,Noise>):Work{
    return self.toArrowlet().prepare(Noise,cont);
  }
  static public function control<O,E>(self:Proceed<O,E>,rec:Recover<O,E>):Forward<O>{
    return Forward.lift(self.then(rec.toResolve()));
  }
}