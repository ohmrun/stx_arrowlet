package stx.channel.pack.channel;

class Destructure extends Clazz{
  public function or<I,II,O,E>(that:Channel<II,O,E>,self:Channel<I,O,E>):Channel<Either<I,II>,O,E>{
    return Channel.lift(__.arw().cont(
      (ipt:Outcome<Either<I,II>,E>,cont:Sink<Outcome<O,E>>) -> 
        switch(ipt){
          case Right(Left(l))   : self.prepare(Right(l),cont);
          case Right(Right(r))  : that.prepare(Right(r),cont);
          case Left(e)          : cont(Left(e),Automation.inj().unit());
        }
    ));
  }
}