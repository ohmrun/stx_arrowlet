package stx.arrowlet;

class Package{}

typedef Amb<I,O>                        = stx.arrowlet.pack.Amb<I,O>;
typedef Apply<I,O>                      = stx.arrowlet.pack.Apply<I,O>;
typedef Both<A,B,C,D>                   = stx.arrowlet.pack.Both<A,B,C,D>;
typedef Bounce<T>                       = stx.arrowlet.pack.Bounce<T>;
//typedef Crank<I,O>                      = stx.arrowlet.pack.Crank<I,O>;
typedef FunctionArrowlet<I,O>           = stx.arrowlet.pack.FunctionArrowlet<I,O>;
typedef LeftChoice<B,C,D>               = stx.arrowlet.pack.LeftChoice<B,C,D>;
typedef State<S,A>                      = stx.arrowlet.pack.State<S,A>;
typedef Then<A,B,C>                     = stx.arrowlet.pack.Then<A,B,C>;
typedef Only<I,O>                       = stx.arrowlet.pack.Only<I,O>;
typedef Arrowlet<I,O>                   = stx.arrowlet.pack.Arrowlet<I,O>;
typedef Or<L, R, R0>                    = stx.arrowlet.pack.Or<L, R, R0>;
typedef Repeat<I,O>                     = stx.arrowlet.pack.Repeat<I,O>;
typedef RightChoice<B,C,D>              = stx.arrowlet.pack.RightChoice<B,C,D>;
typedef Unit<I>                         = stx.arrowlet.pack.Unit<I>;
//typedef Windmill<S,A>                   = stx.arrowlet.pack.Windmill<S,A>;

typedef Arrowlets                       = stx.arrowlet.body.Arrowlets;
//typedef Cranks                          = stx.arrowlet.body.Cranks;
typedef States                          = stx.arrowlet.body.States;