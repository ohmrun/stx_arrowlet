package stx;

typedef Terminal<R,E>                         = stx.arrowlet.core.pack.Terminal<R,E>;
typedef Work                                  = stx.arrowlet.core.pack.Work;

typedef ArrowletDef<I,O,E>                    = stx.arrowlet.core.pack.Arrowlet.ArrowletDef<I,O,E>;
typedef ArrowletApi<I,O,E>                    = stx.arrowlet.core.pack.Arrowlet.ArrowletApi<I,O,E>;
typedef ArrowletBase<I,O,E>                   = stx.arrowlet.core.pack.Arrowlet.ArrowletBase<I,O,E>;
typedef Arrowlet<I,O,E>                       = stx.arrowlet.core.pack.Arrowlet<I,O,E>;

typedef ApplyDef<I,O,E>                       = stx.arrowlet.core.pack.arrowlet.term.Apply.ApplyDef<I,O,E>;
typedef Apply<I,O,E>                          = stx.arrowlet.core.pack.arrowlet.term.Apply<I,O,E>;

//typedef RightChoice<B,C,D>                    = ArrowletA<Either<D,B>,Either<D,C>>
//typedef ActionDef                             = Arrowlet<Noise,Noise>;
//typedef LeftChoiceDef<I,Oi,Oii>               = ArrowletDef<Either<I,Oii>,Either<Oi,Oii>>;
//typedef OrDef<Ii,Iii,O>                       = ArrowletDef<Either<Ii,Iii>,O>;
//typedef BothDef<Ii,Oi,Iii,Oii>                = ArrowletDef<Couple<Ii,Iii>,Couple<Oi,Oii>>;
//typedef OnlyDef<I,O>                          = ArrowletDef<Option<I>,Option<O>>;

//TODO FOLDL?
//typedef RepeatDef<I,O,E>                      = ArrowletDef<I,Either<I,O>,E>;

//typedef State<S,A>                            = stx.arrowlet.core.pack.State<S,A>;
//typedef States                                = stx.arrowlet.core.body.States;

//typedef Repeat<I,O>                           = stx.arrowlet.core.pack.Repeat<I,O>;


typedef LiftChoiceToArrowlet                  = stx.arrowlet.core.lift.LiftChoiceToArrowlet;
typedef LiftReplyFutureToArrowlet             = stx.arrowlet.core.lift.LiftReplyFutureToArrowlet;
typedef LiftFun1FutureToArrowlet              = stx.arrowlet.core.lift.LiftFun1FutureToArrowlet;
typedef LiftFun1RToArrowlet                   = stx.arrowlet.core.lift.LiftFun1RToArrowlet;
typedef LiftFun2RToArrowlet                   = stx.arrowlet.core.lift.LiftFun2RToArrowlet;
typedef LiftFutureToArrowlet                  = stx.arrowlet.core.lift.LiftFutureToArrowlet;
typedef LiftHandlerToArrowlet                 = stx.arrowlet.core.lift.LiftHandlerToArrowlet;
typedef LiftThunkToArrowlet                   = stx.arrowlet.core.lift.LiftThunkToArrowlet;
typedef LiftToLeftChoice                      = stx.arrowlet.core.lift.LiftToLeftChoice;
typedef LiftToRightChoice                     = stx.arrowlet.core.lift.LiftToRightChoice;
typedef LiftFutureToForward                   = stx.arrowlet.core.lift.LiftFutureToForward;
typedef LiftFun1RToProcess                    = stx.arrowlet.core.lift.LiftFun1RToProcess;
typedef ArrowletLift                          = stx.arrowlet.core.pack.Arrowlet.ArrowletLift;

typedef Thread                                = stx.arrowlet.core.pack.arrowlet.term.Thread;
typedef CascadeDef<I,O,E>                     = stx.arrowlet.pack.Cascade.CascadeDef<I,O,E>;
typedef Cascade<I,O,E>                        = stx.arrowlet.pack.Cascade<I,O,E>;
//typedef CascadeLift                           = stx.arrowlet.pack.Cascade.CascadeLift;


/**
         ________O_______
        /
  Noise<
        \_____ Err<E>____
**/
typedef ProceedDef<O,E>                       = stx.arrowlet.pack.Proceed.ProceedDef<O,E>;
typedef Proceed<O,E>                          = stx.arrowlet.pack.Proceed<O,E>;

typedef CommandDef<I,E>                       = stx.arrowlet.pack.Command.CommandDef<I,E>;
typedef Command<I,E>                          = stx.arrowlet.pack.Command<I,E>;

typedef RectifyDef<I,O,E>                     = stx.arrowlet.pack.Rectify.RectifyDef<I,O,E>;
typedef Rectify<I,O,E>                        = stx.arrowlet.pack.Rectify<I,O,E>;

typedef ResolveDef<I,E>                       = stx.arrowlet.pack.Resolve.ResolveDef<I,E>;
typedef Resolve<I,E>                          = stx.arrowlet.pack.Resolve<I,E>;

typedef RecoverDef<I,E>                       = stx.arrowlet.pack.Recover.RecoverDef<I,E>;
typedef Recover<I,E>                          = stx.arrowlet.pack.Recover<I,E>;

typedef ProcessDef<I,O>                       = stx.arrowlet.pack.Process.ProcessDef<I,O>;
typedef Process<I,O>                          = stx.arrowlet.pack.Process<I,O>;

typedef ForwardDef<O>                         = stx.arrowlet.pack.Forward.ForwardDef<O>;
typedef Forward<O>                            = stx.arrowlet.pack.Forward<O>;

typedef ExecuteDef<E>                         = stx.arrowlet.pack.Execute.ExecuteDef<E>;
typedef Execute<E>                            = stx.arrowlet.pack.Execute<E>;

typedef ProvideDef<O,E>                       = stx.arrowlet.pack.Provide.ProvideDef<O,E>;
typedef Provide<O,E>                          = stx.arrowlet.pack.Provide<O,E>;

typedef AttemptDef<I,O,E>                     = stx.arrowlet.pack.Attempt.AttemptDef<I,O,E>;
typedef Attempt<I,O,E>                        = stx.arrowlet.pack.Attempt<I,O,E>;

typedef ReframeDef<I,O,E>                     = stx.arrowlet.pack.Reframe.ReframeDef<I,O,E>;
typedef Reframe<I,O,E>                        = stx.arrowlet.pack.Reframe<I,O,E>;

typedef ArrangeDef<I,S,O,E>                   = stx.arrowlet.pack.Arrange.ArrangeDef<I,S,O,E>;
typedef Arrange<I,S,O,E>                      = stx.arrowlet.pack.Arrange<I,S,O,E>;


#if (test=="stx_arrowlet")
  typedef Test                                = stx.arrowlet.core.pack.Test;
#end
class LiftArrowletToCascade{
   static public function toCascade<A,B,E>(arw:Arrowlet<A,B,E>):Cascade<A,B,E>{
    return Cascade.fromArrowlet(arw);
  }
}
class LiftRectifyToCascade{
  static public function toCascade<A,B,E>(arw:Arrowlet<Res<A,E>,B,Noise>):Cascade<A,B,E>{
   return Rectify.lift(arw).toCascade();
  }
}
class LiftAttemptToCascade{
  static public function toCascade<A,B,E>(arw:Arrowlet<A,Res<B,E>,Noise>):Cascade<A,B,E>{
   return Attempt.lift(arw).toCascade();
 }
}
class LiftRecoverToCascade{
  // static public function toCascade<A,E>(arw:Arrowlet<Err<E>,A,Nois>):Cascade<A,A,E>{
  //  return Cascade.fromRecover(arw);
  // }
}
class LiftExecuteToCascade{
  static public function toCascade<A,E>(arw:Arrowlet<A,Report<E>,Noise>):Cascade<A,A,E>{
   return Command.lift(arw).toCascade();
  }
}
class LiftAttemptFunctionToAttempt{
  static public function toAttempt<PI,R,E>(fn:PI->Res<R,E>):Attempt<PI,R,E>{
    return Attempt.fromFun1Res(fn);
  }
}
typedef LiftThunkToProceed        = stx.arrowlet.lift.LiftThunkToProceed;
typedef LiftFun1ProceedToAttempt  = stx.arrowlet.core.lift.LiftFun1ProceedToAttempt;
typedef LiftFun1ResToCascade      = stx.arrowlet.core.lift.LiftFun1ResToCascade;