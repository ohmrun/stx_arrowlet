package stx.channel.pack;

import stx.channel.head.data.Arrange in ArrangeT;

//typedef Arrange<S,A,R,E> = Attempt<Tuple2<A,S>,R,E>;

@:forward abstract Arrange<S,A,R,E>(ArrangeT<S,A,R,E>) from ArrangeT<S,A,R,E> to ArrangeT<S,A,R,E>{
  public function new(self) this = self;
  static public function lift<S,A,R,E>(self:ArrangeT<S,A,R,E>):Arrange<S,A,R,E> return new Arrange(self);
  static public function pure<S,A,R,E>(r:R) return lift(Attempt.lift(__.arw().fn()( (tp:Tuple2<A,S>) -> __.success(r))));

  

  public function prj():ArrangeT<S,A,R,E> return this;
  private var self(get,never):Arrange<S,A,R,E>;
  private function get_self():Arrange<S,A,R,E> return lift(this);

  public function state():Arrange<S,A,Tuple2<R,S>,E>{
    return( new Arrange(this.broach().postfix(
      __.into2(
        (tp:Tuple2<A,S>,chk:Outcome<R,E>) -> chk.map(tuple2.bind(_,tp.snd()))
      )
    )));
  }
  
  public function toArrowlet():Arrowlet<Tuple2<A,S>,Outcome<R,E>>{
    return this;
  }
}