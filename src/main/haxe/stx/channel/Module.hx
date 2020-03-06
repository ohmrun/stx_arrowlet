package stx.channel;

import stx.channel.head.data.Channel in ChannelT;

class Module extends Clazz{

  public function unit<I,E>():Channel<I,I,E>{
    return Channel.unit();
  }
  public function lift<I,O,E>(fn:ChannelT<I,O,E>):Channel<I,O,E>{
    return Channels.lift(fn);
  }
  public function io<I,O,E>(fn:I->IO<O,E>):Attempt<I,O,E>{
    
    return Attempt.lift(
      new ReceiverArrowlet(fn.fn().then( io -> io.wait().prj()))
    );
  }
  public function eio<I,E>(fn:I->EIO<E>):Command<I,E>{
   return Command.lift(
      Arrowlet.lift(Recall.anon(
        (i,cont:Sink<Report<E>>) -> fn(i).apply(cont)
      ))
   );
  }
  public function err<I,E>(fn:I->Option<TypedError<E>>):Command<I,E>{
    return Command.lift(
      __.arw().fn(fn.fn().then(e -> new Report(e)))
    );
  }
  public function outcome<I,O,E>(arw:Arrowlet<I,Outcome<O,E>>):Attempt<I,O,E>{
    return Attempt.lift(arw);
  }
  public function either<I,O,E>(arw:Arrowlet<I,Either<TypedError<E>,O>>):Attempt<I,O,E>{
    return Attempt.lift(arw.postfix(Outcome.inj.lift));
  }
  // public function reframe<I,O,Z,E>(fN:O->Channel<I,Z,E>):Channel<I,O,E>->Reframe<I,Z,E>{
  //   return (chn:Channel<I,O,E>) -> chn.reframe().arrange(
  //     Arrange.lift(__.arw().cont(
  //       (ipt:Tuple2<O,I>,cont:Sink<Outcome<Z,E>>) -> fN(ipt.fst()).prepare(ipt.snd(),cont)
  //     ))
  //   );
  // }
  public function process<I,O,E>(arw:Arrowlet<I,O>):Channel<I,O,E>{
    return Channels.fromArrowlet(arw);
  }
  public function arranger<A,S,Z,E>(f:A->Attempt<S,Z,E>):Arrange<S,A,Z,E>{
    var fN =  Attempt.lift(__.arw().unit().postfix(
      __.into2(
        (l:A,r:S) -> (tuple2(f(l).toArrowlet(),r):Tuple2<Arrowlet<S,Outcome<Z,E>>,S>)
      )
    ).then(__.arw().apply().toArrowlet()));
    return fN;
  }
  
  public function bind_fold<S,A,E,T>(fn:T->A->Attempt<S,A,E>,array:Array<T>):Option<Arrange<S,A,A,E>>{
   return array
    .map(_ -> (fn.bind1(_):A->Attempt<S,A,E>))
    .map(arranger)
    .lfold1(
      (next:Arrange<S,A,A,E>,memo:Arrange<S,A,A,E>) ->  {
        return memo.state().attempt(next.toArrowlet());
      }
    );
  }

}