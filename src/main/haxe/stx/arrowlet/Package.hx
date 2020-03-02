package stx.arrowlet;

class Package{
  
}

typedef Amb<I,O>                        = stx.arrowlet.core.pack.Amb<I,O>;
typedef Apply<I,O>                      = stx.arrowlet.core.pack.Apply<I,O>;
typedef Both<A,B,C,D>                   = stx.arrowlet.core.pack.Both<A,B,C,D>;
//typedef Bounce<T>                       = stx.arrowlet.core.pack.Bounce<T>;
typedef FunctionArrowlet<I,O>           = stx.arrowlet.core.pack.FunctionArrowlet<I,O>;
typedef CallbackArrowlet<I,O>           = stx.arrowlet.core.pack.CallbackArrowlet<I,O>;
typedef ReceiverArrowlet<I,O>           = stx.arrowlet.core.pack.ReceiverArrowlet<I,O>;
typedef ReactArrowlet<I,O>              = stx.arrowlet.core.pack.ReactArrowlet<I,O>;

typedef LeftChoice<B,C,D>               = stx.arrowlet.core.pack.LeftChoice<B,C,D>;
typedef State<S,A>                      = stx.arrowlet.core.pack.State<S,A>;
typedef Then<A,B,C>                     = stx.arrowlet.core.pack.Then<A,B,C>;
typedef Only<I,O>                       = stx.arrowlet.core.pack.Only<I,O>;
typedef Arrowlet<I,O>                   = stx.arrowlet.core.pack.Arrowlet<I,O>;
typedef Or<L, R, R0>                    = stx.arrowlet.core.pack.Or<L, R, R0>;
//typedef Repeat<I,O>                     = stx.arrowlet.core.pack.Repeat<I,O>;
typedef RightChoice<B,C,D>              = stx.arrowlet.core.pack.RightChoice<B,C,D>;

typedef Unit<I>                         = stx.arrowlet.core.pack.Unit<I>;
typedef Action                          = stx.arrowlet.core.pack.Action;


typedef Arrowlets                       = stx.arrowlet.core.head.Arrowlets;


typedef States                          = stx.arrowlet.core.body.States;

typedef Construct<I,O>                  = stx.arrowlet.core.pack.Construct<I,O>;

#if (test=="stx_arrowlet")
  typedef Test                          =stx.arrowlet.core.pack.Test;
#end
