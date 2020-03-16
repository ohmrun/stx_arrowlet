package stx.channel;

typedef ChannelDef<I,O,E>               = ArrowletDef<Outcome<I,E>,Outcome<O,E>>;
typedef Channel<I,O,E>                  = stx.channel.pack.Channel<I,O,E>;

typedef AttemptDef<I,O,E>               = ArrowletDef<I,Outcome<O,E>>;
typedef Attempt<I,O,E>                  = stx.channel.pack.Attempt<I,O,E>;

typedef ResolveDef<I,O,E>               = ArrowletDef<Outcome<I,E>,O>;
typedef Resolve<I,O,E>                  = stx.channel.pack.Resolve<I,O,E>;

typedef RecoverDef<I,E>                 = ArrowletDef<TypedError<E>,I>;
typedef Recover<I,E>                    = stx.channel.pack.Recover<I,E>;

typedef ExecuteDef<E>                   = ArrowletDef<Noise,TypedError<E>>;
typedef Execute<E>                      = stx.channel.pack.Execute<E>;

typedef CommandDef<I,E>                 = ArrowletDef<I,Report<E>>;
typedef Command<I,E>                    = stx.channel.pack.Command<I,E>;

typedef ProceedDef<O,E>                 = ArrowletDef<Noise,Outcome<O,E>>;
typedef Proceed<O,E>                    = stx.channel.pack.Proceed<O,E>;

typedef ReframeDef<I,O,E>               = ChannelDef<I,Tuple2<O,I>,E>;
typedef Reframe<I,O,E>                  = stx.channel.pack.Reframe<I,O,E>;

typedef ArrangeDef<I,S,O,E>             = AttemptDef<Tuple2<I,S>,O,E>;
typedef Arrange<I,S,O,E>                = stx.channel.pack.Arrange<I,S,O,E>;

//typedef PerformDef                      = Arrowlet<Noise,Noise>;

class LiftArrowletToChannel{
  static public function toChannel<A,B,E>(arw:Arrowlet<A,B>):Channel<A,B,E>{
    return Channel.fromArrowlet(arw);
  }
}
class LiftResolveToChannel{
  static public function toChannel<A,B,E>(arw:Arrowlet<Outcome<A,E>,B>):Channel<A,B,E>{
    return Channel.fromResolve(arw);
  }
}
class LiftAttemptToChannel{
  static public function toChannel<A,B,E>(arw:Arrowlet<A,Outcome<B,E>>):Channel<A,B,E>{
    return Channel.fromAttempt(arw);
  }
}
class LiftRecoverToChannel{
  static public function toChannel<A,E>(arw:Arrowlet<TypedError<E>,A>):Channel<A,A,E>{
    return Channel.fromRecover(arw);
  }
}
class LiftExecuteToChannel{
  static public function toChannel<A,E>(arw:Arrowlet<A,Option<TypedError<E>>>):Channel<A,A,E>{
    return Channel.fromCommand(arw);
  }
}
class LiftAttemptFunctionToAttempt{
  static public function toAttempt<PI,R,E>(fn:PI->Outcome<R,E>):Attempt<PI,R,E>{
    return Attempt.fromAttemptFunction(fn);
  }
}

class LiftExecutesFromEIOConstructor{
  static public function toCommand<PI,E>(fn:PI->EIO<E>):Command<PI,E>{
    return Command.fromFun1EIO(fn);
  }
}