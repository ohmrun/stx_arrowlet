package stx;

class Arw{
  static public function Fun<I,O,E>(fn:I->O):Arrowlet<I,O,E>{
    return Arrowlet.Sync(fn);
  }
}
//typedef Terminal<R,E>                         = stx.arw.Terminal<R,E>;
//typedef Work                                  = stx.arw.Work;

typedef ArrowletDef<I,O,E>                      = stx.arw.Arrowlet.ArrowletDef<I,O,E>;
typedef ArrowletApi<I,O,E>                      = stx.arw.Arrowlet.ArrowletApi<I,O,E>;
typedef ArrowletBase<I,O,E>                     = stx.arw.Arrowlet.ArrowletBase<I,O,E>;
typedef Arrowlet<I,O,E>                         = stx.arw.Arrowlet<I,O,E>;

typedef ApplyDef<I,O,E>                         = stx.arw.arrowlet.term.Apply.ApplyDef<I,O,E>;
typedef Apply<I,O,E>                            = stx.arw.arrowlet.term.Apply<I,O,E>;

//typedef RightChoice<B,C,D>                    = ArrowletA<Either<D,B>,Either<D,C>>
//typedef ActionDef                             = Arrowlet<Noise,Noise>;
//typedef LeftChoiceDef<I,Oi,Oii>               = ArrowletDef<Either<I,Oii>,Either<Oi,Oii>>;
//typedef OrDef<Ii,Iii,O>                       = ArrowletDef<Either<Ii,Iii>,O>;
//typedef BothDef<Ii,Oi,Iii,Oii>                = ArrowletDef<Couple<Ii,Iii>,Couple<Oi,Oii>>;
//typedef OnlyDef<I,O>                          = ArrowletDef<Option<I>,Option<O>>;

//TODO FOLDL?
//typedef RepeatDef<I,O,E>                      = ArrowletDef<I,Either<I,O>,E>;
//typedef Repeat<I,O>                           = stx.arw.Repeat<I,O>;

//typedef State<S,A>                            = stx.arw.State<S,A>;
//typedef States                                = stx.arw.core.body.States;




typedef LiftChoiceToArrowlet                  = stx.arw.lift.LiftChoiceToArrowlet;
typedef LiftReplyFutureToArrowlet             = stx.arw.lift.LiftReplyFutureToArrowlet;
typedef LiftFun1FutureToArrowlet              = stx.arw.lift.LiftFun1FutureToArrowlet;
typedef LiftFun1RToArrowlet                   = stx.arw.lift.LiftFun1RToArrowlet;
typedef LiftFun2RToArrowlet                   = stx.arw.lift.LiftFun2RToArrowlet;
typedef LiftFutureToArrowlet                  = stx.arw.lift.LiftFutureToArrowlet;
typedef LiftHandlerToArrowlet                 = stx.arw.lift.LiftHandlerToArrowlet;
typedef LiftThunkToArrowlet                   = stx.arw.lift.LiftThunkToArrowlet;
typedef LiftToLeftChoice                      = stx.arw.lift.LiftToLeftChoice;
typedef LiftToRightChoice                     = stx.arw.lift.LiftToRightChoice;
typedef LiftFutureToForward                   = stx.arw.lift.LiftFutureToForward;
typedef LiftFun1RToProcess                    = stx.arw.lift.LiftFun1RToProcess;
typedef ArrowletLift                          = stx.arw.Arrowlet.ArrowletLift;

typedef Thread                                = stx.arw.arrowlet.term.Thread;
typedef CascadeDef<I,O,E>                     = stx.arw.Cascade.CascadeDef<I,O,E>;
typedef Cascade<I,O,E>                        = stx.arw.Cascade<I,O,E>;
//typedef CascadeLift                           = stx.arw.Cascade.CascadeLift;


/**
         ________O_______
        /
  Noise<
        \_____ Err<E>____
**/
typedef ProceedDef<O,E>                       = stx.arw.Proceed.ProceedDef<O,E>;
typedef Proceed<O,E>                          = stx.arw.Proceed<O,E>;

typedef CommandDef<I,E>                       = stx.arw.Command.CommandDef<I,E>;
typedef Command<I,E>                          = stx.arw.Command<I,E>;

typedef RectifyDef<I,O,E>                     = stx.arw.Rectify.RectifyDef<I,O,E>;
typedef Rectify<I,O,E>                        = stx.arw.Rectify<I,O,E>;

typedef ResolveDef<I,E>                       = stx.arw.Resolve.ResolveDef<I,E>;
typedef Resolve<I,E>                          = stx.arw.Resolve<I,E>;

typedef RecoverDef<I,E>                       = stx.arw.Recover.RecoverDef<I,E>;
typedef Recover<I,E>                          = stx.arw.Recover<I,E>;

typedef ProcessDef<I,O>                       = stx.arw.Process.ProcessDef<I,O>;
typedef Process<I,O>                          = stx.arw.Process<I,O>;

typedef ForwardDef<O>                         = stx.arw.Forward.ForwardDef<O>;
typedef Forward<O>                            = stx.arw.Forward<O>;

typedef ExecuteDef<E>                         = stx.arw.Execute.ExecuteDef<E>;
typedef Execute<E>                            = stx.arw.Execute<E>;

typedef ProvideDef<O,E>                       = stx.arw.Provide.ProvideDef<O,E>;
typedef Provide<O,E>                          = stx.arw.Provide<O,E>;

typedef AttemptDef<I,O,E>                     = stx.arw.Attempt.AttemptDef<I,O,E>;
typedef Attempt<I,O,E>                        = stx.arw.Attempt<I,O,E>;

typedef ReframeDef<I,O,E>                     = stx.arw.Reframe.ReframeDef<I,O,E>;
typedef Reframe<I,O,E>                        = stx.arw.Reframe<I,O,E>;

typedef ArrangeDef<I,S,O,E>                   = stx.arw.Arrange.ArrangeDef<I,S,O,E>;
typedef Arrange<I,S,O,E>                      = stx.arw.Arrange<I,S,O,E>;

typedef PerformDef                            = stx.arw.Perform.PerformDef;
typedef Perform                               = stx.arw.Perform;

typedef ExudateDef<I,O,E>                     = stx.arw.Exudate.ExudateDef<I,O,E>;
typedef Exudate<I,O,E>                        = stx.arw.Exudate<I,O,E>;

#if (test=="stx_arw")
  typedef Test                                = stx.arw.Test;
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
typedef LiftThunkToProceed                = stx.arw.lift.LiftThunkToProceed;
typedef LiftFun1ProceedToAttempt          = stx.arw.lift.LiftFun1ProceedToAttempt;
typedef LiftFun1ResToCascade              = stx.arw.lift.LiftFun1ResToCascade;
typedef LiftFun1AttemptToArrange          = stx.arw.lift.LiftFun1AttemptToArrange;
typedef LiftProceedOfOptionIRToProvide    = stx.arw.lift.LiftProceedOfOptionIRToProvide;

typedef Arch                              = stx.arw.Arch;