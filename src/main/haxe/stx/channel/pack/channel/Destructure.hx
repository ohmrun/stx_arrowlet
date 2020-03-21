package stx.channel.pack.channel;

class Destructure extends Clazz{
  private function lift<I,O,E>(self:ArrowletDef<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return new Channel(self);
  }
  private function unto<I,O,E>(self:Arrowlet<Res<I,E>,Res<O,E>>):Channel<I,O,E>{
    return lift(self.asRecallDef());
  }

  public function or<Ii,Iii,O,E>(that:Channel<Iii,O,E>,self:Channel<Ii,O,E>):Channel<Either<Ii,Iii>,O,E>{
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
  
  public function errata<I,O,E,EE>(fn:Err<E>->Err<EE>,self:Channel<I,O,E>):Channel<I,O,EE>{
    return lift(
      Recall.Anon(
        (i:Res<I,EE>,cont:Sink<Res<O,EE>>) -> i.fold(
          (i) -> self.postfix(o -> o.errata(fn)).applyII(__.success(i),cont),
          typical_fail_handler(cont)
        )
      )
    );
  }
  
  public function reframe<I,O,E>(self:Channel<I,O,E>):Reframe<I,O,E>{ 
    return Recall.Anon((ipt:Res<I,E>,cont:Sink<Res<Couple<O,I>,E>>) -> {
      return self.prepare(ipt,
        (opt:Res<O,E>) -> cont(opt.zip(ipt))
      );
    });
  }
  public function forward<I,O,E>(i:I,self:Channel<I,O,E>):IO<O,E>{
    return IO.fromIODef((auto,next:Sink<Res<O,E>>) ->
      return auto.snoc(self.prepare(__.success(i),next))
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


  static function typical_fail_handler<O,E>(cont:Sink<Res<O,E>>){
    return (e:Err<E>) -> {
      cont(__.failure(e));
      return Automation.unit();
    }
  }
}