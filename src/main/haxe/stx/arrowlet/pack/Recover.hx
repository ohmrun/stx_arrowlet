package stx.arrowlet.pack;

typedef RecoverDef<I,E>                 = ArrowletDef<Err<E>,I,Noise>;

@:forward abstract Recover<I,E>(RecoverDef<I,E>) from RecoverDef<I,E> to RecoverDef<I,E>{
  public function new(self){
    this = self;
  }
  public function toCascade():Cascade<I,I,E>{    
    return Cascade.lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<Res<I,E>,Noise>) -> i.fold(
        (i) -> {
          cont.value(__.success(i));
          return cont.serve();
        },
        (e:Err<E>) -> {
          var inner = cont.inner();
              inner.later(
                (res:Outcome<I,Noise>) -> {
                  cont.value(
                    res.fold(
                      (i) -> __.success(i),
                      (_) -> __.failure(__.fault().err(FailCode.E_ResourceNotFound))
                    )
                  );
                }
              );
          cont.after(this.prepare(e,inner));
          return cont.serve();
        }
      )
    ));
  }
  public function prj():RecoverDef<I,E>{
    return this;
  }
} 