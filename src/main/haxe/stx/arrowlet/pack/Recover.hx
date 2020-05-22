package stx.arrowlet.pack;

typedef RecoverDef<I,E>                 = ArrowletDef<Err<E>,I,Noise>;

@:forward abstract Recover<I,E>(RecoverDef<I,E>) from RecoverDef<I,E> to RecoverDef<I,E>{
  public function new(self) this = self;
  @:noUsing static public function lift<I,E>(self:RecoverDef<I,E>) return new Recover(self);

  @:from static public function fromFunErrR<I,E>(fn:Err<E>->I):Recover<I,E>{
    return lift(Arrowlet.Sync(fn));
  }
  public function toCascade():Cascade<I,I,E>{    
    return Cascade.lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<Res<I,E>,Noise>) -> i.fold(
        (i) -> {
          return cont.value(__.success(i)).serve();
        },
        (e:Err<E>) -> {
          var defer = Future.trigger();
          var inner = cont.inner(
            (res:Outcome<I,Noise>) -> {
              defer.trigger(Success(
                res.fold(
                  (i) -> __.success(i),
                  (_) -> __.failure(__.fault().err(FailCode.E_ResourceNotFound))
                )
              ));
            }
          );
          return cont.defer(defer).after(this.prepare(e,inner));
        }
      )
    ));
  }
  public function toRectify():Rectify<I,I,E>{
    return Rectify.lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<I,Noise>) -> i.fold(
        (i) -> cont.value(i).serve(),
        (e) -> {
          var defer = Future.trigger();
          var inner = cont.inner(
            (res:Outcome<I,Noise>) -> {
              defer.trigger(res);
            }
          );
          return cont.defer(defer).after(this.prepare(e,inner));
        }
      )
    ));
  }
  public function prj():RecoverDef<I,E>{
    return this;
  }
} 