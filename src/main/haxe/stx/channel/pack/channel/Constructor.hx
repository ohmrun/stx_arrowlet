package stx.channel.pack.channel;

class Constructor extends Clazz{
  static public var ZERO(default,never) = new Constructor();
  public var _(default,null) = new Destructure();

  public function lift<I,O,E>(self:ArrowletDef<Outcome<I,E>,Outcome<O,E>>):Channel<I,O,E>{
    return new Channel(self);
  }
  public function unto<I,O,E>(self:Arrowlet<Outcome<I,E>,Outcome<O,E>>):Channel<I,O,E>{
    return new Channel(self.asRecallDef());
  }
  public function unit<I,O,E>():Channel<I,I,E>{
    return unto(Arrowlet.fromFun1R(
      (oc:Outcome<I,E>) -> oc
    ));
  }
  public function pure<I,O,E>(ocO:Outcome<O,E>):Channel<I,O,E>{
    return unto(Arrowlet.fromFun1R(
      (ocI:Outcome<I,E>) -> ocI.fold(
        (i:I)               -> ocO,
        (e:TypedError<E>)   -> __.failure(e)
      )
    ));
  }
  public function fromArrowlet<I,O,E>(arw:Arrowlet<I,O>):Channel<I,O,E>{
    return Recall.Anon(
      (i:Outcome<I,E>,cont:Sink<Outcome<O,E>>) -> i.fold(
        (i:I) -> arw.then(__.success).prepare(i,cont),
        typical_fail_handler(cont)
      )
    );
  }
  public function fromAttempt<I,O,E>(arw:Arrowlet<I,Outcome<O,E>>):Channel<I,O,E>{
    return Recall.Anon(
      (i:Outcome<I,E>,cont:Sink<Outcome<O,E>>) -> i.fold(
        (i) -> arw.prepare(i,cont),
        typical_fail_handler(cont)
      )
    );
  }
  public function fromResolve<I,O,E>(arw:Arrowlet<Outcome<I,E>,O>):Channel<I,O,E>{
    return unto(arw.postfix(__.success));
  }
  public function fromRecover<I,E>(arw:Arrowlet<TypedError<E>,I>):Channel<I,I,E>{
    return Recall.Anon(
      (i:Outcome<I,E>,cont) -> i.fold(
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
  public function fromCommand<I,E>(arw:Arrowlet<I,Option<TypedError<E>>>):Channel<I,I,E>{
    return Recall.Anon(
      (i:Outcome<I,E>,cont:Sink<Outcome<I,E>>) -> i.fold(
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
  public function fromProceed<O,E>(arw:Arrowlet<Noise,Outcome<O,E>>):Channel<Noise,O,E>{
    return Recall.Anon(
      (i:Outcome<Noise,E>,cont:Sink<Outcome<O,E>>) -> i.fold(
        (_) -> arw.prepare(_,cont),
        typical_fail_handler(cont)
      )
    );
  }
  static function typical_fail_handler<O,E>(cont:Sink<Outcome<O,E>>){
    return (e:TypedError<E>) -> {
      cont(__.failure(e));
      return Automation.unit();
    }
  }
}