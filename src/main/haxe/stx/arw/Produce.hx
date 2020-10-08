package stx.arw;

typedef ProduceDef<O,E> = ArrowletDef<Noise,Res<O,E>,Noise>;

@:using(stx.arw.Produce.ProduceLift)
@:using(stx.arw.Arrowlet.ArrowletLift)
@:provide(then) abstract Produce<O,E>(ProduceDef<O,E>) from ProduceDef<O,E> to ProduceDef<O,E>{
  static public var _(default,never) = ProduceLift;

  public function new(self:ProduceDef<O,E>) this = self;

  @:noUsing static public function lift<O,E>(self:ProduceDef<O,E>):Produce<O,E> return new Produce(self);

  @:from @:noUsing static public function fromFunXProduce<O,E>(self:Void->Produce<O,E>):Produce<O,E>{
    return lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<Res<O,E>,Noise>) -> self().prepare(cont)
    ));
  }
  @:noUsing static public function fromErr<O,E>(e:Err<E>):Produce<O,E>{
    return lift(Arrowlet.pure(__.reject(e)));
  }
  @:noUsing static public function pure<O,E>(v:O):Produce<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> __.accept(v)));
  }
  @:from @:noUsing static public function fromRes<O,E>(res:Res<O,E>):Produce<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> res));
  }
  @:from @:noUsing static public function fromFunXRes<O,E>(fn:Void->Res<O,E>):Produce<O,E>{
    return lift(Arrowlet.fromFun1R((_:Noise) -> fn()));
  }
  #if stx_ext
  @:from @:noUsing static public function fromPledge<O,E>(pl:Pledge<O,E>):Produce<O,E>{
    return lift(
      Arrowlet.Anon(      
        (_:Noise,cont:Terminal<Res<O,E>,Noise>) -> {
          return cont.defer(pl.map(Success).toSlot()).serve();
        }
      )
    );
  }
  #end
  @:noUsing static public function fromFunXR<O,E>(fn:Void->O):Produce<O,E>{
    return lift(
      Arrowlet.fromFun1R(
        (_:Noise) -> __.accept(fn())
      )
    );
  }
  @:noUsing static public function fromArrowlet<O,E>(arw:Arrowlet<Noise,O,E>):Produce<O,E>{
    return lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<Res<O,E>,Noise>) ->  {
        var defer = Future.trigger();
        var inner = cont.inner(
              (outcome:Outcome<O,E>) -> {
                //trace("INNER");
                defer.trigger(Success(
                  outcome.fold(
                    __.accept,
                    (e) -> __.reject(__.fault().of(e))
                  )
                ));
              }
            );
        return cont.defer(defer).after(arw.prepare(Noise,inner)); 
      })
    );
  }
  static public function fromProvide<O,E>(self:Provide<Res<O,E>>):Produce<O,E>{
    return Produce.lift(Arrowlet.Anon(
      (_:Noise,cont:Terminal<Res<O,E>,Noise>) -> self.prepare(cont)
    ));
  }
  public inline function environment(success:O->Void,failure:Err<E>->Void):Thread{
    return Arrowlet._.environment(
      this,
      Noise,
      (res:Res<O,E>) -> {
        res.fold(success,failure);
      },
      __.crack
    );
  }
  @:to public function toArrowlet():Arrowlet<Noise,Res<O,E>,Noise>{
    return this;
  }
  @:to public function toPropose():Propose<O,E>{
    return Propose.lift(this.then((res:Res<O,E>) -> res.fold(Val,End)));
  }
  private var self(get,never):Produce<O,E>;
  private function get_self():Produce<O,E> return this;

}
class ProduceLift{
  @:noUsing static private function lift<O,E>(self:ProduceDef<O,E>):Produce<O,E> return Produce.lift(self);
  
  static public function postfix<I,O,Z,E>(self:Produce<O,E>,fn:O->Z):Produce<Z,E>{
    return lift(self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.map(fn)
      )
    ));
  }
  static public function errata<O,E,EE>(self:Produce<O,E>,fn:Err<E>->Err<EE>):Produce<O,EE>{
    return lift(self.then(
      Arrowlet.fromFun1R(
        (oc:Res<O,E>) -> oc.errata(fn)
      )
    ));
  }
  static public function errate<O,E,EE>(self:Produce<O,E>,fn:E->EE):Produce<O,EE>{
    return errata(self,(er) -> er.map(fn));
  }
  static public function point<O,E>(self:Produce<O,E>,success:O->Execute<E>):Execute<E>{
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
  static public function crack<O,E>(self:Produce<O,E>):Provide<O>{
    return Provide.lift(
      Arrowlet._.postfix(self,
        res -> res.fold(
          (ok)  -> ok,
          (e)   -> throw(e)
        )
      )
    );
  }
  @:deprecated
  static public function report<O,E>(self:Produce<O,E>):Provide<O>{
    return crack(self);
  }
  static public function convert<O,Oi,E>(self:Produce<O,E>,then:Convert<O,Oi>):Produce<Oi,E>{
    return lift(Arrowlet.Then(self,then.toCascade()));
  }
  static public function prepare<O,E>(self:Produce<O,E>,cont:Terminal<Res<O,E>,Noise>):Work{
    return self.toArrowlet().prepare(Noise,cont);
  }
  static public function control<O,E>(self:Produce<O,E>,rec:Recover<O,E>):Provide<O>{
    return Provide.lift(self.then(rec.toRectify()));
  }
  static public function attempt<O,Oi,E>(self:Produce<O,E>,that:Attempt<O,Oi,E>):Produce<Oi,E>{
    return lift(self.then(that.toCascade()));
  }
  static public function deliver<O,E>(self:Produce<O,E>,fn:O->Void):Execute<E>{
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
  static public function reclaim<O,Oi,E>(self:Produce<O,E>,next:Convert<O,Produce<Oi,E>>):Produce<Oi,E>{
    return lift(
      self.then(
        next.toCascade()
      )).attempt(
        Attempt.lift(Arrowlet.Anon(
          (prd:Produce<Oi,E>,cont:Terminal<Res<Oi,E>,Noise>) ->
            prd.prepare(cont)
        ))
      );
  }
  static public function arrange<S,O,Oi,E>(self:Produce<O,E>,next:Arrange<O,S,Oi,E>):Attempt<S,Oi,E>{
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
  static public function rearrange<S,O,Oi,E>(self:Produce<O,E>,next:Arrange<Res<O,E>,S,Oi,E>):Attempt<S,Oi,E>{
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
  static public function cascade<O,Oi,E>(self:Produce<O,E>,that:Cascade<O,Oi,E>):Produce<Oi,E>{
    return lift(self.then(that));
  }
  static public function fudge<O,E>(self:Produce<O,E>):O{
    return Arrowlet._.fudge(self,Noise).fudge();
  }
  static public function flat_map<O,Oi,E>(self:Produce<O,E>,that:O->Produce<Oi,E>):Produce<Oi,E>{
    return lift(
      Arrowlet.FlatMap(
        self,
        (res:Res<O,E>) -> res.fold(
          (o) -> that(o),
          (e) -> Produce.fromRes(__.reject(e))
        )
      )
    );
  }
  static public function then<O,Oi,E,EE>(self:Produce<O,E>,that:Arrowlet<Res<O,E>,Oi,Noise>):Provide<Oi>{
    return Provide.lift(Arrowlet.Then(
      self,
      that
    ));
  }
}