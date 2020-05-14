package stx.arrowlet.pack;

typedef ProcessDef<I,O> = ArrowletDef<I,O,Noise>;

@:using(stx.arrowlet.pack.Process.ProcessLift)
abstract Process<I,O>(ProcessDef<I,O>) from ProcessDef<I,O> to ProcessDef<I,O>{
  static public var _(default,never) = ProcessLift;
  public function new(self) this = self;
  static public function lift<I,O>(self:ProcessDef<I,O>):Process<I,O> return new Process(self);
  


  public function toArrowlet():ArrowletDef<I,O,Noise>{
    return this;
  }
  private var self(get,never):Process<I,O>;
  private function get_self():Process<I,O> return lift(this);

  public function toCascade<E>():Cascade<I,O,E>{
    return Cascade.lift(
      Arrowlet.Anon(
        (i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>) ->
          i.fold(
            (i) -> {
              var defer = Future.trigger();
              var inner = cont.inner(
                (outcome:Outcome<O,Noise>) -> {
                  defer.trigger(Success(outcome.fold(
                    __.success,
                    (_) -> __.failure(__.fault().err(FailCode.E_ResourceNotFound))
                  )));
                }
              );
              return cont.defer(defer).after(this.prepare(i,inner));
            },
            (err) -> {
              return cont.value(__.failure(err)).serve();
            }
          )
      )
    );
  }
  @:from static public function fromFun1R<I,O>(fn:I->O):Process<I,O>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<O,Noise>) -> {
          return cont.value(fn(i)).serve();
        }
      )
    );
  }
  @:from static public function fromArrowlet<I,O>(arw:Arrowlet<I,O,Noise>){
    return lift(arw);
  }
}
class ProcessLift{
  static public function then<I,O,Oi>(self:ProcessDef<I,O>,that:Process<O,Oi>):Process<I,Oi>{
    return Process.lift(Arrowlet.Then(
      self,
      that
    ));
  }
}