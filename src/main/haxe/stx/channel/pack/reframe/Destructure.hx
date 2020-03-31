package stx.channel.pack.reframe;


class ReframeLift extends Clazz{
  static private function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  static private function unto<I,O,E>(wml:Arrowlet<Res<I,E>,Res<Couple<O,I>,E>>):Reframe<I,O,E> return new Reframe(wml.asRecallDef());
  
  static public function attempt<I,O,Oi,E>(self:Reframe<I,O,E>,that:Attempt<O,Oi,E>):Reframe<I,Oi,E>{
    var fn = (chk:Res<Couple<Res<Oi,E>,I>,E>) -> (chk.flat_map(
      (tp) -> tp.fst().map(
        (r) -> __.couple(r,tp.snd())
      )
    ):Res<Couple<Oi,I>,E>);
    var arw =  unto(
      self.process(
        that.first()
      ).postfix(fn)
    );
    return arw;
  }
  static public function arrange<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrange<O,I,Oi,E>):Reframe<I,Oi,E>{
    var arw = lift(
      self.then(that.toChannel())
        .broach()
        .postfix(
          (tp:Couple<Res<I,E>,Res<Oi,E>>) -> 
            tp.decouple(
              (l,r) -> switch([l,r]){
                case [Success(s),Success(z)]  : __.success(__.couple(z,s));
                default                       : __.decouple(Res._()._.zip)(tp);
              }
            )
        )
    );
    return arw;
  }

  static public function rearrange<I,Ii,O,Oi,E>(self:Reframe<I,O,E>,that:O->Arrange<Ii,I,Oi,E>):Attempt<Couple<Ii,I>,Oi,E>{
    return Recall.Anon(
      (ipt:Couple<Ii,I>,contN:Sink<Res<Oi,E>>) -> self.prepare(__.success(ipt.snd()),
         (chk:Res<Couple<O,I>,E>) -> 
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

  static public function commander<I,O,E>(self:Reframe<I,O,E>,fN:O->Command<I,E>):Reframe<I,O,E>{
    return lift(Recall.Anon(
      (ipt:Res<I,E>,contN:Sink<Res<Couple<O,I>,E>>) ->
        self.prepare(
          ipt,
          (out:Res<Couple<O,I>,E>) -> out.fold(
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
  static public function evaluation<I,O,E>(self:Reframe<I,O,E>):Channel<I,O,E>{
    return self.postfix(o -> o.map(tp -> tp.fst()));
  }

  static public function execution<I,O,E>(self:Reframe<I,O,E>):Channel<I,I,E>{
    return self.postfix(o -> o.map(tp -> tp.snd()));
  }
}