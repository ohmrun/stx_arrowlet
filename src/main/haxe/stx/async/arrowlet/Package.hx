package stx.async.arrowlet;

class Package{}

typedef Amb<I,O>                        = stx.async.arrowlet.body.Amb<I,O>;
typedef Apply<I,O>                      = stx.async.arrowlet.body.Apply<I,O>;
typedef Arrowlet<I,O>                   = stx.async.arrowlet.body.Arrowlet<I,O>;
typedef Arrowlets                       = stx.async.arrowlet.body.Arrowlets;
typedef Both<A,B,C,D>                   = stx.async.arrowlet.body.Both<A,B,C,D>;
typedef Crank<I,O>                      = stx.async.arrowlet.body.Crank<I,O>;
typedef Cranks                          = stx.async.arrowlet.body.Cranks;
typedef FunctionArrowlet<I,O>           = stx.async.arrowlet.body.FunctionArrowlet<I,O>;
typedef LeftChoice<B,C,D>               = stx.async.arrowlet.body.LeftChoice<B,C,D>;
typedef Lift                            = stx.async.arrowlet.body.Lift;
typedef Only<I,O>                       = stx.async.arrowlet.body.Only<I,O>;
typedef Or<L, R, R0>                    = stx.async.arrowlet.body.Or<L, R, R0>;
typedef Repeat<I,O>                     = stx.async.arrowlet.body.Repeat<I,O>;
typedef RightChoice<B,C,D>              = stx.async.arrowlet.body.RightChoice<B,C,D>;
typedef RightSwitch<A,B,C,D>            = stx.async.arrowlet.body.RightSwitch<A,B,C,D>;
typedef State<S,A>                      = stx.async.arrowlet.body.State<S,A>;
typedef States                          = stx.async.arrowlet.body.States;
typedef Then<A,B,C>                     = stx.async.arrowlet.body.Then<A,B,C>;
typedef Unit<I>                         = stx.async.arrowlet.body.Unit<I>;
typedef Windmill<S,A>                   = stx.async.arrowlet.body.Windmill<S,A>;
