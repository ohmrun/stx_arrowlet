package stx.channel.pack;

import stx.channel.head.data.Command in CommandT;

import stx.channel.type.Reframe           in ReframeT;
import stx.arrowlet.core.head.data.State     in StateT;


@:callable @:forward abstract Reframe<S,A,E>(ReframeT<S,A,E>) from ReframeT<S,A,E> to ReframeT<S,A,E>{
  public function new(self) this = self;
  static public function lift<S,A,E>(wml:ReframeT<S,A,E>):Reframe<S,A,E> return new Reframe(wml);
  static public function pure<S,A,E>(a:A):Reframe<S,A,E>{
    return lift(Channel.unit().postfix(
      (s:S) -> tuple2(a,s)
    ));
  }
  static public function unit<S,A,E>():Reframe<S,A,E>{
    return lift(
      Channel.unit().prj().then(
        __.arw().fn()(
          (chk:Chunk<S,E>) -> (Tap:Chunk<Tuple2<A,S>,E>)
        )
      )  
    );
  }
  public function attempt<R>(that:Attempt<A,R,E>):Reframe<S,R,E>{
    var fn = (chk:Chunk<Tuple2<Chunk<R,E>,S>,E>) -> chk.fmap(
      (tp) -> tp.fst().map(
        (r) -> tuple2(r,tp.snd())
      )
    );
    var arw =  lift(
      this.process(
        that.first()
      ).then(
        __.arw().fn()(fn)
      )
    );
    return arw;
  }
  public function arrange<Z>(that:Arrange<S,A,Z,E>):Reframe<S,Z,E>{
    var arw = lift(
      this.then(that.toChannel())
        .prj()
        .broach()
        .postfix(
          (tp:Tuple2<Chunk<S,E>,Chunk<Z,E>>) -> switch(tp){
            case tuple2(Val(s),Val(z))  : Val(tuple2(z,s));
            case tuple2(l,r)            : __.into2(Chunks._.zip)(tp);
          }
        )
    );
    return arw;
  }
  public function commander<Z>(fN:A->Command<S,E>):Reframe<S,A,E>{
    return lift(__.arw().cont()(
      (ipt:Chunk<S,E>,contN:Continue<Chunk<Tuple2<A,S>,E>>) ->
        this.prepare(
          ipt,
          Continue.lift(
            (out:Chunk<Tuple2<A,S>,E>,auto) -> out.fold(
              (tp) -> fN(tp.fst()).postfix(
                (opt) -> opt.fold(
                  (err) -> End(err),
                  ()    -> Val(tp)
                )
              ).prepare(tp.snd(),contN),
              (err) -> contN(End(err),Automation.unit()),
              ()    -> contN(Tap,Automation.unit())
            )
          )
        )
    ));
  }
  @:deprecated
  public function evaluate():Channel<S,A,E>{
    return this.postfix(tp -> tp.fst());
  }
  public function evaluation():Channel<S,A,E>{
    return this.postfix(tp -> tp.fst());
  }
  public function execution():Channel<S,S,E>{
    return this.postfix(tp -> tp.snd());
  }
}
 