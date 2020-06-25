package stx.arrowlet.pack;

typedef ProcessDef<I,O> = ArrowletDef<I,O,Noise>;

/**
  An Arrowlet with no fail case
**/
@:using(stx.arrowlet.pack.Process.ProcessLift)
abstract Process<I,O>(ProcessDef<I,O>) from ProcessDef<I,O> to ProcessDef<I,O>{
  static public var _(default,never) = ProcessLift;
  public function new(self) this = self;
  static public function lift<I,O>(self:ProcessDef<I,O>):Process<I,O> return new Process(self);
  static public function unit<I>():Process<I,I> return lift(Arrowlet.Sync((i:I)->i));


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
              var defer : FutureTrigger<Outcome<Res<O,E>,Noise>> = Future.trigger();
              var inner = cont.inner(
                (outcome:Outcome<O,Noise>) -> {
                  defer.trigger(outcome.fold(
                    (s) -> Success(__.success(s)),
                    (_) -> Failure(Noise)
                  ));
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
  public function environment(i:I,success:O->Void):Thread{
    return Arrowlet._.environment(
      this,
      i,
      success,
      __.raise
    );
  }
}
class ProcessLift{
  static public function then<I,O,Oi>(self:ProcessDef<I,O>,that:Process<O,Oi>):Process<I,Oi>{
    return Process.lift(Arrowlet.Then(
      self,
      that
    ));
  }
  static public function forward<I,O,Oi>(self:ProcessDef<I,O>,i:I):Forward<O>{
    return Forward.lift(Arrowlet._.fulfill(self,i));
  }
  static public function process<I,O,Oi>(self:ProcessDef<I,O>,that:ProcessDef<O,Oi>):Process<I,Oi>{
    return Process.lift(
      Arrowlet.Then(
        self,
        that
      )
    );
  }
}