package stx.arrowlet;

class Package{}

typedef Amb<I,O>                        = stx.arrowlet.core.pack.Amb<I,O>;
typedef Apply<I,O>                      = stx.arrowlet.core.pack.Apply<I,O>;
typedef Both<A,B,C,D>                   = stx.arrowlet.core.pack.Both<A,B,C,D>;
typedef Bounce<T>                       = stx.arrowlet.core.pack.Bounce<T>;
//typedef Crank<I,O>                      = stx.arrowlet.core.pack.Crank<I,O>;
typedef FunctionArrowlet<I,O>           = stx.arrowlet.core.pack.FunctionArrowlet<I,O>;
typedef LeftChoice<B,C,D>               = stx.arrowlet.core.pack.LeftChoice<B,C,D>;
typedef State<S,A>                      = stx.arrowlet.core.pack.State<S,A>;
typedef Then<A,B,C>                     = stx.arrowlet.core.pack.Then<A,B,C>;
typedef Only<I,O>                       = stx.arrowlet.core.pack.Only<I,O>;
typedef Arrowlet<I,O>                   = stx.arrowlet.core.pack.Arrowlet<I,O>;
typedef Or<L, R, R0>                    = stx.arrowlet.core.pack.Or<L, R, R0>;
typedef Repeat<I,O>                     = stx.arrowlet.core.pack.Repeat<I,O>;
typedef RightChoice<B,C,D>              = stx.arrowlet.core.pack.RightChoice<B,C,D>;
typedef Unit<I>                         = stx.arrowlet.core.pack.Unit<I>;
//typedef Windmill<S,A>                   = stx.arrowlet.pack.Windmill<S,A>;

typedef Arrowlets                       = stx.arrowlet.core.body.Arrowlets;
//typedef Cranks                          = stx.arrowlet.body.Cranks;
typedef States                          = stx.arrowlet.core.body.States;