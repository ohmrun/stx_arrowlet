package stx.channel.pack.reframe;


class Destructure extends Clazz{
  private function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  private function unto<I,O,E>(wml:Arrowlet<Outcome<I,E>,Outcome<Tuple2<O,I>,E>>):Reframe<I,O,E> return new Reframe(wml.asRecallDef());

  public function attempt<I,O,Oi,E>(that:Attempt<O,Oi,E>,self:Reframe<I,O,E>):Reframe<I,Oi,E>{
    var fn = (chk:Outcome<Tuple2<Outcome<Oi,E>,I>,E>) -> (chk.fmap(
      (tp) -> tp.fst().map(
        (r) -> tuple2(r,tp.snd())
      )
    ):Outcome<Tuple2<Oi,I>,E>);
    var arw =  unto(
      self.process(
        that.first()
      ).postfix(fn)
    );
    return arw;
  }

  public function arrange<I,O,Oi,E>(that:Arrange<O,I,Oi,E>,self:Reframe<I,O,E>):Reframe<I,Oi,E>{
    var arw = lift(
      self.then(that.toChannel())
        .broach()
        .postfix(
          (tp:Tuple2<Outcome<I,E>,Outcome<Oi,E>>) -> switch(tp){
            case tuple2(Right(s),Right(z))  : __.success(tuple2(z,s));
            case tuple2(l,r)                : __.into2(Outcome.inj._.zip)(tp);
          }
        )
    );
    return arw;
  }

  public function rearrange<I,Ii,O,Oi,E>(that:O->Arrange<Ii,I,Oi,E>,self:Reframe<I,O,E>):Attempt<Tuple2<Ii,I>,Oi,E>{
    return Recall.Anon(
      (ipt:Tuple2<Ii,I>,contN:Sink<Outcome<Oi,E>>) -> self.prepare(Right(ipt.snd()),
         (chk:Outcome<Tuple2<O,I>,E>) -> 
         chk.fold(
           (tp) -> that(tp.fst()).prepare(ipt.map(_ -> tp.snd()),contN),
           (e)  -> {
              contN(__.failure(e));
              return Automation.unit();
           }
         )
      )
    );
  }

  public function commander<I,O,E>(fN:O->Command<I,E>,self:Reframe<I,O,E>):Reframe<I,O,E>{
    return lift(Recall.Anon(
      (ipt:Outcome<I,E>,contN:Sink<Outcome<Tuple2<O,I>,E>>) ->
        self.prepare(
          ipt,
          (out:Outcome<Tuple2<O,I>,E>) -> out.fold(
            (tp) -> fN(tp.fst()).postfix(
              (opt) -> opt.fold(
                (err) -> __.failure(err),
                ()    -> __.success(tp)
              )
            ).prepare(tp.snd(),contN),
            (err) -> {
              contN(__.failure(err));
              return Automation.unit();
            }
          )
        )
    ));
  }
  public function evaluation<I,O,E>(self:Reframe<I,O,E>):Channel<I,O,E>{
    return self.postfix(o -> o.map(tp -> tp.fst()));
  }

  public function execution<I,O,E>(self:Reframe<I,O,E>):Channel<I,I,E>{
    return self.postfix(o -> o.map(tp -> tp.snd()));
  }
  
}