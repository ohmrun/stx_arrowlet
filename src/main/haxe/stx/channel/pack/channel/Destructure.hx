package stx.channel.pack.channel;

class Destructure extends Clazz{
  private function lift<I,O,E>(self:ArrowletDef<Outcome<I,E>,Outcome<O,E>>):Channel<I,O,E>{
    return new Channel(self);
  }
  private function unto<I,O,E>(self:Arrowlet<Outcome<I,E>,Outcome<O,E>>):Channel<I,O,E>{
    return lift(self.asRecallDef());
  }

  public function or<Ii,Iii,O,E>(that:Channel<Iii,O,E>,self:Channel<Ii,O,E>):Channel<Either<Ii,Iii>,O,E>{
    return lift(
      Recall.Anon(
        (ipt:Outcome<Either<Ii,Iii>,E>,cont:Sink<Outcome<O,E>>) -> 
          (switch(ipt){
            case Right(Left(l))   : self.prepare(Right(l),cont);
            case Right(Right(r))  : that.prepare(Right(r),cont);
            case Left(e)          : typical_fail_handler(cont)(e);
          }:Automation)
      )
    );
  }
  
  public function errata<I,O,E,EE>(fn:TypedError<E>->TypedError<EE>,self:Channel<I,O,E>):Channel<I,O,EE>{
    return lift(
      Recall.Anon(
        (i:Outcome<I,EE>,cont:Sink<Outcome<O,EE>>) -> i.fold(
          (i) -> self.postfix(o -> o.errata(fn)).duoply(__.success(i),cont),
          typical_fail_handler(cont)
        )
      )
    );
  }
  
  public function reframe<I,O,E>(self:Channel<I,O,E>):Reframe<I,O,E>{ 
    return Recall.Anon((ipt:Outcome<I,E>,cont:Sink<Outcome<Tuple2<O,I>,E>>) -> {
      return self.prepare(ipt,
        (opt:Outcome<O,E>) -> cont(opt.zip(ipt))
      );
    });
  }
  public function forward<I,O,E>(i:I,self:Channel<I,O,E>):IO<O,E>{
    return IO.fromIOT((auto,next:Sink<Outcome<O,E>>) ->
      return auto.snoc(self.prepare(Right(i),next))
    );
  }
  public function attempt<I,O,Oi,E>(that:Attempt<O,Oi,E>,self:Channel<I,O,E>):Channel<I,Oi,E>{
    return self.then(that.toChannel());  
  }
  public function process<I,O,Oi,E>(that:Arrowlet<O,Oi>,self:Channel<I,O,E>):Channel<I,Oi,E>{
    return self.then(Channel.fromArrowlet(that));
  }
  public function postfix<I,O,Oi,E>(fn:O->Oi,self:Channel<I,O,E>){
    return process(Arrowlet.fromFun1R(fn),self);
  }
  public function prefix<I,Ii,O,E>(fn:Ii->I,self:Channel<I,O,E>){
    return Channel.fromArrowlet(Arrowlet.fromFun1R(fn)).then(self);
  }


  static function typical_fail_handler<O,E>(cont:Sink<Outcome<O,E>>){
    return (e:TypedError<E>) -> {
      cont(__.failure(e));
      return Automation.unit();
    }
  }
}