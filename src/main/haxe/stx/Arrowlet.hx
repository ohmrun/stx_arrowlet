package stx;

//Channel -> Cascade

typedef ArrowletDef<I,O>                      = Recall<I,O,Automation>;
typedef Arrowlet<I,O>                         = stx.arrowlet.core.pack.Arrowlet<I,O>;

typedef ApplyDef<I,O>                         = ArrowletDef<Couple<Arrowlet<I,O>,I>,O>;
typedef Apply<I,O>                            = stx.arrowlet.core.pack.Apply<I,O>;

//typedef ActionDef                             = Arrowlet<Noise,Noise>;
//typedef LeftChoiceDef<I,Oi,Oii>               = ArrowletDef<Either<I,Oii>,Either<Oi,Oii>>;
//typedef OrDef<Ii,Iii,O>                       = ArrowletDef<Either<Ii,Iii>,O>;
//typedef BothDef<Ii,Oi,Iii,Oii>                = ArrowletDef<Couple<Ii,Iii>,Couple<Oi,Oii>>;
//typedef OnlyDef<I,O>                          = ArrowletDef<Option<I>,Option<O>>;

typedef RepeatDef<I,O>                        = ArrowletDef<I,Either<I,O>>;

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

typedef ArrowletLift                          = stx.arrowlet.core.pack.Arrowlet.ArrowletLift;


#if (test=="stx_arrowlet")
  typedef Test                                = stx.arrowlet.core.pack.Test;
#end