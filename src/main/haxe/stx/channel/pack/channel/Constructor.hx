package stx.channel.pack.channel;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,null) = new Destructure();

  public function lift<I,O,E>(self:ArrowletDef<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return new Channel(self);
  }
  public function unto<I,O,E>(self:Arrowlet<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return new Channel(self.asRecallDef());
  }
  public function unit<I,O,E>():Channel<I,I,E>{
    return unto(Arrowlet.fromFun1R(
      (oc:Res<I,E>) -> oc
    ));
  }
  public function pure<I,O,E>(ocO:Res<O,E>):Channel<I,O,E>{
    return unto(Arrowlet.fromFun1R(
      (ocI:Res<I,E>) -> ocI.fold(
        (i:I)               -> ocO,
        (e:Err<E>)   -> __.failure(e)
      )
    ));
  }
  public function fromArrowlet<I,O,E>(arw:Arrowlet<I,O>):Channel<I,O,E>{
    return Recall.Anon(
      (i:Res<I,E>,cont:Sink<Res<O,E>>) -> i.fold(
        (i:I) -> arw.then(__.success).prepare(i,cont),
        typical_fail_handler(cont)
      )
    );
  }
  public function fromAttempt<I,O,E>(arw:Arrowlet<I,Res<O,E>>):Channel<I,O,E>{
    return Recall.Anon(
      (i:Res<I,E>,cont:Sink<Res<O,E>>) -> i.fold(
        (i) -> arw.prepare(i,cont),
        typical_fail_handler(cont)
      )
    );
  }
  public function fromResolve<I,O,E>(arw:Arrowlet<Res<I,E>,O>):Channel<I,O,E>{
    return unto(arw.postfix(__.success));
  }
  public function fromRecover<I,E>(arw:Arrowlet<Err<E>,I>):Channel<I,I,E>{
    return Recall.Anon(
      (i:Res<I,E>,cont) -> i.fold(
        (i) -> {
          cont(__.success(i));
          return Automation.unit();
        },
        (e) -> {
          cont(__.failure(e));
          return Automation.unit();
        }
      )
    );
  }
  public function fromCommand<I,E>(arw:Arrowlet<I,Option<Err<E>>>):Channel<I,I,E>{
    return Recall.Anon(
      (i:Res<I,E>,cont:Sink<Res<I,E>>) -> i.fold(
        (i) -> arw.prepare(i,
          (opt) -> opt.fold(
            e   -> typical_fail_handler(cont)(e),
            ()  -> {
              cont(__.success(i));
              return Automation.unit();
            }
          )  
        ),
        typical_fail_handler(cont)
      )
    );
  }
  public function fromProceed<O,E>(arw:Arrowlet<Noise,Res<O,E>>):Channel<Noise,O,E>{
    return Recall.Anon(
      (i:Res<Noise,E>,cont:Sink<Res<O,E>>) -> i.fold(
        (_) -> arw.prepare(_,cont),
        typical_fail_handler(cont)
      )
    );
  }
  static function typical_fail_handler<O,E>(cont:Sink<Res<O,E>>){
    return (e:Err<E>) -> {
      cont(__.failure(e));
      return Automation.unit();
    }
  }
}