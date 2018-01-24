package stx.arrowlet.head;

class Data{

}
typedef Apply<I,O>              = stx.arrowlet.head.data.Apply<I,O>;
//typedef Crank<I,O>              = stx.arrowlet.head.data.Crank<I,O>;
typedef State<S,A>              = stx.arrowlet.head.data.State<S,A>;
typedef Both<A,B,C,D>           = stx.arrowlet.head.data.Both<A,B,C,D>;
typedef Repeat<I,O>             = stx.arrowlet.head.data.Repeat<I,O>;
typedef LeftChoice<B,C,D>       = stx.arrowlet.head.data.LeftChoice<B,C,D>;
typedef RightChoice<B,C,D>      = stx.arrowlet.head.data.RightChoice<B,C,D>;
typedef Only<I,O>               = stx.arrowlet.head.data.Only<I,O>;
