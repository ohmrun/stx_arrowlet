package stx;

class Arw{
  static public function ctx<P,R,E>(wildcard:Wildcard,p:P):Contextualize<P,R,E>{
    return Contextualize.pure(p);
  }
  @:noUsing static public function Fun<I,O,E>(fn:I->O):Arrowlet<I,O,E>{
    return Arrowlet.Sync(fn);
  }
  static public function name<I,O,E>(arw:ArrowletDef<I,O,E>):String{
    return __.definition(arw).identifier().name();
  }
  // static public inline function after<I,O,E>(self:stx.async.Terminal.Receiver<O,E>,arrowlet:Arrowlet<I,O,E>,i:I,cont:Terminal<O,E>):Work{
  //   return Arrowlet._.prepare(arrowlet,i,cont).seq(lift(self).serve());
  // }
}
typedef ArrowletFailure                         = stx.fail.ArrowletFailure;
typedef ArrowletDef<I,O,E>                      = stx.arw.ArrowletDef<I,O,E>;
typedef ArrowletApi<I,O,E>                      = stx.arw.ArrowletApi<I,O,E>;
typedef ArrowletCls<I,O,E>                      = stx.arw.ArrowletCls<I,O,E>;
typedef Arrowlet<I,O,E>                         = stx.arw.Arrowlet<I,O,E>;
typedef ArrowletLift                            = stx.arw.arrowlet.ArrowletLift;

typedef ApplierDef<I,O,E>                         = stx.arw.arrowlet.term.Applier.Applier<I,O,E>;
typedef Applier<I,O,E>                            = stx.arw.arrowlet.term.Applier<I,O,E>;

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
typedef LiftFutureToProvide                   = stx.arw.lift.LiftFutureToProvide;
typedef LiftFun1RToConvert                    = stx.arw.lift.LiftFun1RToConvert;


typedef Fiber                                 = stx.arw.arrowlet.term.Fiber;
typedef CascadeDef<I,O,E>                     = stx.arw.Cascade.CascadeDef<I,O,E>;
typedef Cascade<I,O,E>                        = stx.arw.Cascade<I,O,E>;
//typedef CascadeLift                           = stx.arw.Cascade.CascadeLift;


/**
         ________O_______
        /
  Noise<
        \_____ Err<E>____
**/
typedef ProduceDef<O,E>                       = stx.arw.Produce.ProduceDef<O,E>;
typedef Produce<O,E>                          = stx.arw.Produce<O,E>;

typedef CommandDef<I,E>                       = stx.arw.Command.CommandDef<I,E>;
typedef Command<I,E>                          = stx.arw.Command<I,E>;

typedef RectifyDef<I,O,E>                     = stx.arw.Rectify.RectifyDef<I,O,E>;
typedef Rectify<I,O,E>                        = stx.arw.Rectify<I,O,E>;

typedef ResolveDef<I,E>                       = stx.arw.Resolve.ResolveDef<I,E>;
typedef Resolve<I,E>                          = stx.arw.Resolve<I,E>;

typedef RecoverDef<I,E>                       = stx.arw.Recover.RecoverDef<I,E>;
typedef Recover<I,E>                          = stx.arw.Recover<I,E>;

typedef ConvertDef<I,O>                       = stx.arw.Convert.ConvertDef<I,O>;
typedef Convert<I,O>                          = stx.arw.Convert<I,O>;

typedef ProvideDef<O>                         = stx.arw.Provide.ProvideDef<O>;
typedef Provide<O>                            = stx.arw.Provide<O>;

typedef ExecuteDef<E>                         = stx.arw.Execute.ExecuteDef<E>;
typedef Execute<E>                            = stx.arw.Execute<E>;

typedef ProposeDef<O,E>                       = stx.arw.Propose.ProposeDef<O,E>;
typedef Propose<O,E>                          = stx.arw.Propose<O,E>;

typedef AttemptDef<I,O,E>                     = stx.arw.Attempt.AttemptDef<I,O,E>;
typedef Attempt<I,O,E>                        = stx.arw.Attempt<I,O,E>;

typedef ReframeDef<I,O,E>                     = stx.arw.Reframe.ReframeDef<I,O,E>;
typedef Reframe<I,O,E>                        = stx.arw.Reframe<I,O,E>;

typedef ArrangeDef<I,S,O,E>                   = stx.arw.Arrange.ArrangeDef<I,S,O,E>;
typedef Arrange<I,S,O,E>                      = stx.arw.Arrange<I,S,O,E>;

typedef PerformDef                            = stx.arw.Perform.PerformDef;
typedef Perform                               = stx.arw.Perform;

typedef DiffuseDef<I,O,E>                     = stx.arw.Diffuse.DiffuseDef<I,O,E>;
typedef Diffuse<I,O,E>                        = stx.arw.Diffuse<I,O,E>;

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
typedef LiftThunkToProduce                = stx.arw.lift.LiftThunkToProduce;
typedef LiftFun1ProduceToAttempt          = stx.arw.lift.LiftFun1ProduceToAttempt;
typedef LiftFun1ResToCascade              = stx.arw.lift.LiftFun1ResToCascade;
typedef LiftFun1AttemptToArrange          = stx.arw.lift.LiftFun1AttemptToArrange;
typedef LiftProduceOfOptionIRToPropose    = stx.arw.lift.LiftProduceOfOptionIRToPropose;

typedef Arch                              = stx.arw.Arch;
typedef ConventionSum                     = stx.arw.Convention.ConventionSum;
typedef Convention                        = stx.arw.Convention;
typedef Fulfill<I,O,E>                    = stx.arw.arrowlet.term.Fulfill<I,O,E>;
typedef Deliver<I,O,E>                    = stx.arw.arrowlet.term.Deliver<I,O,E>;
typedef Contextualize<P,R,E>              = stx.arw.Contextualize<P,R,E>;