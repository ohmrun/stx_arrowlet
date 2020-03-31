package stx.channel.pack;

@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:using(stx.channel.pack.Channel.ChannelLift)
@:forward abstract Channel<I,O,E>(ChannelDef<I,O,E>) from ChannelDef<I,O,E> to ChannelDef<I,O,E>{
  static public var _(default,never) = ChannelLift;
  public function new(self) this = self;
  
  static public function lift<I,O,E>(self:ArrowletDef<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return new Channel(self);
  }
  static public function unto<I,O,E>(self:Arrowlet<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return new Channel(self.asRecallDef());
  }
  static public function unit<I,O,E>():Channel<I,I,E>{
    return unto(Arrowlet.fromFun1R(
      (oc:Res<I,E>) -> oc
    ));
  }
  static public function pure<I,O,E>(ocO:Res<O,E>):Channel<I,O,E>{
    return unto(Arrowlet.fromFun1R(
      (ocI:Res<I,E>) -> ocI.fold(
        (i:I)               -> ocO,
        (e:Err<E>)   -> __.failure(e)
      )
    ));
  }
  static public function fromArrowlet<I,O,E>(arw:Arrowlet<I,O>):Channel<I,O,E>{
    return Recall.Anon(
      (i:Res<I,E>,cont:Sink<Res<O,E>>) -> i.fold(
        (i:I) -> arw.then(__.success).prepare(i,cont),
        typical_fail_handler(cont)
      )
    );
  }
  static public function fromAttempt<I,O,E>(arw:Arrowlet<I,Res<O,E>>):Channel<I,O,E>{
    return Recall.Anon(
      (i:Res<I,E>,cont:Sink<Res<O,E>>) -> i.fold(
        (i) -> arw.prepare(i,cont),
        typical_fail_handler(cont)
      )
    );
  }
  static public function fromResolve<I,O,E>(arw:Arrowlet<Res<I,E>,O>):Channel<I,O,E>{
    return unto(arw.postfix(__.success));
  }
  static public function fromRecover<I,E>(arw:Arrowlet<Err<E>,I>):Channel<I,I,E>{
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
  static public function fromCommand<I,E>(arw:Arrowlet<I,Option<Err<E>>>):Channel<I,I,E>{
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
  static public function fromProceed<O,E>(arw:Arrowlet<Noise,Res<O,E>>):Channel<Noise,O,E>{
    return Recall.Anon(
      (i:Res<Noise,E>,cont:Sink<Res<O,E>>) -> i.fold(
        (_) -> arw.prepare(_,cont),
        typical_fail_handler(cont)
      )
    );
  }
  static private function typical_fail_handler<O,E>(cont:Sink<Res<O,E>>){
    return (e:Err<E>) -> {
      cont(__.failure(e));
      return Automation.unit();
    }
  }
  @:to public function toArw():Arrowlet<Res<I,E>,Res<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return lift(self.asRecallDef());
  }
}
class ChannelLift{
  static private function lift<I,O,E>(self:ArrowletDef<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return new Channel(self);
  }
  static private function unto<I,O,E>(self:Arrowlet<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return lift(self.asRecallDef());
  }

  static public function or<Ii,Iii,O,E>(self:Channel<Ii,O,E>,that:Channel<Iii,O,E>):Channel<Either<Ii,Iii>,O,E>{
    return lift(
      Recall.Anon(
        (ipt:Res<Either<Ii,Iii>,E>,cont:Sink<Res<O,E>>) -> 
          (switch(ipt){
            case Success(Left(l))       : self.prepare(Success(l),cont);
            case Success(Right(r))      : that.prepare(Success(r),cont);
            case Failure(e)             : typical_fail_handler(cont)(e);
          }:Automation)
      )
    );
  }
  
  static public function errata<I,O,E,EE>(self:Channel<I,O,E>,fn:Err<E>->Err<EE>):Channel<I,O,EE>{
    return lift(
      Recall.Anon(
        (i:Res<I,EE>,cont:Sink<Res<O,EE>>) -> i.fold(
          (i) -> self.postfix(o -> o.errata(fn)).applyII(__.success(i),cont),
          typical_fail_handler(cont)
        )
      )
    );
  }
  
  static public function reframe<I,O,E>(self:Channel<I,O,E>):Reframe<I,O,E>{ 
    return Recall.Anon((ipt:Res<I,E>,cont:Sink<Res<Couple<O,I>,E>>) -> {
      return self.prepare(ipt,
        (opt:Res<O,E>) -> cont(opt.zip(ipt))
      );
    });
  }
  static public function forward<I,O,E>(self:Channel<I,O,E>,i:I):IO<O,E>{
    return IO.fromIODef((auto,next:Sink<Res<O,E>>) ->
      return auto.snoc(self.prepare(__.success(i),next))
    );
  }
  static public function attempt<I,O,Oi,E>(self:Channel<I,O,E>,that:Attempt<O,Oi,E>):Channel<I,Oi,E>{
    return self.then(that.toChannel());  
  }
  static public function process<I,O,Oi,E>(self:Channel<I,O,E>,that:Arrowlet<O,Oi>):Channel<I,Oi,E>{
    return self.then(Channel.fromArrowlet(that));
  }
  static public function postfix<I,O,Oi,E>(self:Channel<I,O,E>,fn:O->Oi):Channel<I,Oi,E>{
    return process(self,Arrowlet.fromFun1R(fn));
  }
  static public function prefix<I,Ii,O,E>(self:Channel<I,O,E>,fn:Ii->I){
    return Channel.fromArrowlet(Arrowlet.fromFun1R(fn)).then(self);
  }


  static function typical_fail_handler<O,E>(cont:Sink<Res<O,E>>){
    return (e:Err<E>) -> {
      cont(__.failure(e));
      return Automation.unit();
    }
  }
}