package stx.arrowlet.pack;

typedef ProceedDef<O,E> = ArrowletDef<Noise,Res<O,E>,Noise>;

@:using(stx.arrowlet.pack.Proceed.ProceedLift)
@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:forward(then) abstract Proceed<O,E>(ProceedDef<O,E>) from ProceedDef<O,E> to ProceedDef<O,E>{
  static public var _(default,never) = ProceedLift;

  public function new(self:ProceedDef<O,E>) this = self;

  @:noUsing static public function lift<O,E>(self:ProceedDef<O,E>):Proceed<O,E> return new Proceed(self);

  @:from @:noUsing static public function fromFunXProceed<O,E>(self:Void->Proceed<O,E>):Proceed<O,E>{
    return lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<Res<O,E>,Noise>) -> self().prepare(cont)
    ));
  }
  @:noUsing static public function pure<O,E>(v:O):Proceed<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> __.success(v)));
  }
  @:from @:noUsing static public function fromRes<O,E>(res:Res<O,E>):Proceed<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> res));
  }
  @:from @:noUsing static public function fromFunXRes<O,E>(fn:Void->Res<O,E>):Proceed<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> fn()));
  }
  #if stx_std
  @:from @:noUsing static public function fromPledge<O,E>(pl:Pledge<O,E>):Proceed<O,E>{
    return lift(
      Arrowlet.Anon(      
        (_:Noise,cont:Terminal<Res<O,E>,Noise>) -> {
          return cont.defer(pl.map(Success)).serve();
        }
      )
    );
  }
  #end
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
  static public function fromForward<O,E>(self:Forward<Res<O,E>>):Proceed<O,E>{
    return Proceed.lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<Res<O,E>,Noise>) -> self.prepare(cont)
    ));
  }
  public function environment(success:O->Void,failure:Err<E>->Void):Thread{
    return Arrowlet._.environment(
      this,
      Noise,
      (res:Res<O,E>) -> {
        res.fold(success,failure);
      },
      __.raise
    );
  }
  @:to public function toArrowlet():Arrowlet<Noise,Res<O,E>,Noise>{
    return this;
  }
  @:to public function toProvide():Provide<O,E>{
    return Provide.lift(this.then((res:Res<O,E>) -> res.fold(Val,End)));
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
  static public function errata<O,E,EE>(self:Proceed<O,E>,fn:Err<E>->Err<EE>):Proceed<O,EE>{
    return lift(self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.errata(fn)
      )
    ));
  }
  static public function errate<O,E,EE>(self:Proceed<O,E>,fn:E->EE):Proceed<O,EE>{
    return errata(self,(er) -> er.map(fn));
  }
  static public function point<O,E>(self:Proceed<O,E>,success:O->Execute<E>):Execute<E>{
    return Execute.lift(
      Arrowlet.Anon(
        (_:Noise,cont:Terminal<Report<E>,Noise>) -> {
          var defer   = Future.trigger();
          var inner   = cont.inner(
            (outcome:Outcome<Res<O,E>,Noise>) -> {
              defer.trigger(
                outcome.fold(
                  (s) -> s.fold(
                    (o) -> success(o).prepare(cont),
                    (e) -> cont.value(Report.pure(e)).serve()
                  ),
                  (_) -> cont.error(Noise).serve()
                )
              );
            }
          );
          return self.prepare(inner).seq(defer);
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
    return Forward.lift(self.then(rec.toRectify()));
  }
  static public function attempt<O,Oi,E>(self:Proceed<O,E>,that:Attempt<O,Oi,E>):Proceed<Oi,E>{
    return lift(self.then(that.toCascade()));
  }
  static public function deliver<O,E>(self:Proceed<O,E>,fn:O->Void):Execute<E>{
    return Execute.lift(self.then(
      Arrowlet.Sync(
        (res:Res<O,E>) -> res.fold(
          (s) -> {
            fn(s);
            return Report.unit();
          },
          (e) -> Report.pure(e)
        )
      )
    ));
  }
  static public function reclaim<O,Oi,E>(self:Proceed<O,E>,next:Process<O,Proceed<Oi,E>>):Proceed<Oi,E>{
    return lift(
      self.then(
        next.toCascade()
      )).attempt(
        Attempt.lift(Arrowlet.Anon(
          (prd:Proceed<Oi,E>,cont:Terminal<Res<Oi,E>,Noise>) ->
            prd.prepare(cont)
        ))
      );
  }
  static public function arrange<S,O,Oi,E>(self:Proceed<O,E>,next:Arrange<O,S,Oi,E>):Attempt<S,Oi,E>{
    return Attempt.lift(Arrowlet.Anon(
      (i:S,cont:Terminal<Res<Oi,E>,Noise>) -> {
        var bound : FutureTrigger<Work> = Future.trigger();
        var inner = cont.inner(
          (outcome:Outcome<Res<O,E>,Noise>) -> {
            var input = outcome.fold(
              (res) -> next.toCascade().prepare(res.map(lhs -> __.couple(lhs,i)),cont),
              (_)   -> cont.error(Noise).serve()
            );
            bound.trigger(input);
          }
        );
        var lhs = self.prepare(inner);
        return lhs.seq(bound);
      })
    );
  }
  static public function rearrange<S,O,Oi,E>(self:Proceed<O,E>,next:Arrange<Res<O,E>,S,Oi,E>):Attempt<S,Oi,E>{
    return Attempt.lift(
      Arrowlet.Anon(
        (i:S,cont:Terminal<Res<Oi,E>,Noise>) -> {
          var bound = Future.trigger();
          var inner = cont.inner(
            (outcome:Outcome<Res<O,E>,Noise>) -> {
              var value = outcome.fold(
                res -> next.prepare(__.couple(res,i),cont),
                _   -> cont.error(Noise).serve()
              );
              bound.trigger(value);
            }
          );
          return self.prepare(inner).seq(bound);
        }
      )
    );
  }
  static public function cascade<O,Oi,E>(self:Proceed<O,E>,that:Cascade<O,Oi,E>):Proceed<Oi,E>{
    return lift(self.then(that));
  }
  static public function fudge<O,E>(self:Proceed<O,E>):O{
    return Arrowlet._.fudge(self,Noise).fudge();
  }
}