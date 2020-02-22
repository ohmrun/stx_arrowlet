package stx.channel;

class Lift{
  static public function  channel(__:Wildcard){
    return new stx.channel.Module();
  }  
}
class LiftArrowletToChannel{
  static public function toChannel<A,B,E>(arw:Arrowlet<A,B>):Channel<A,B,E>{
    return Channels.fromArrowlet(arw);
  }
}
class LiftResolveToChannel{
  static public function toChannel<A,B,E>(arw:Arrowlet<Chunk<A,E>,B>):Channel<A,B,E>{
    return Channels.fromResolve(arw);
  }
}
class LiftAttemptToChannel{
  static public function toChannel<A,B,E>(arw:Arrowlet<A,Chunk<B,E>>):Channel<A,B,E>{
    return Channels.fromAttempt(arw);
  }
}
class LiftRecoverToChannel{
  static public function toChannel<A,E>(arw:Arrowlet<TypedError<E>,A>):Channel<A,A,E>{
    return Channels.fromRecover(arw);
  }
}
class LiftExecuteToChannel{
  static public function toChannel<A,E>(arw:Arrowlet<A,Option<TypedError<E>>>):Channel<A,A,E>{
    return Channels.fromCommand(arw);
  }
}
class LiftAttemptFunctionToAttempt{
  static public function toAttempt<PI,R,E>(fn:PI->Chunk<R,E>):Attempt<PI,R,E>{
    return Attempts.fromAttemptFunction(fn);
  }
}
class LiftExecutesFromEIOConstructor{
  static public function toAttempt<PI,E>(fn:PI->EIO<E>):Command<PI,E>{
    return Commands.fromEIOConstructor(fn);
  }
}