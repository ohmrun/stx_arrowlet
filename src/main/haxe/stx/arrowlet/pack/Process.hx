package stx.arrowlet.pack;

typedef ProcessDef<I,O> = ArrowletDef<I,O,Noise>;

abstract Process<I,O>(ProcessDef<I,O>) from ProcessDef<I,O> to ProcessDef<I,O>{
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
              var inner = cont.inner();
                  inner.later(
                    (outcome:Outcome<O,Noise>) -> {
                      cont.value(outcome.fold(
                        __.success,
                        (_) -> __.failure(__.fault().err(FailCode.E_ResourceNotFound))
                      ));
                    }
                  );
              cont.after(this.prepare(i,inner));
              return cont.serve();
            },
            (err) -> {
              cont.value(__.failure(err));
              return cont.serve();
            }
          )
      )
    );
  }
  @:from static public function fromFun1R<I,O>(fn:I->O):Process<I,O>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<O,Noise>) -> {
          cont.value(fn(i));
          return cont.serve();
        }
      )
    );
  }
}