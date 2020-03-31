package stx.channel.pack;


@:using(stx.channel.pack.Reframe.ReframeLift)
@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:forward abstract Reframe<I,O,E>(ReframeDef<I,O,E>) from ReframeDef<I,O,E> to ReframeDef<I,O,E>{
  static public var _(default,never) = ReframeLift;

  public function new(self) this = self;

  static public function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  static public function pure<I,O,E>(o:O):Reframe<I,O,E>{
    return lift(Channel.unit().postfix(
      (oc:Res<I,E>
        ) -> (oc.map(__.couple.bind(o)):Res<Couple<O,I>,E>)
    ));
  }
  
  

  private var self(get,never):Reframe<I,O,E>;
  private function get_self():Reframe<I,O,E> return this;


  @:to public function toArw():Arrowlet<Res<I,E>,Res<Couple<O,I>,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,O,E>(self:Arrowlet<Res<I,E>,Res<Couple<O,I>,E>>):Reframe<I,O,E>{
    return lift(self.asRecallDef());
  }

  @:to public function toChannel():Channel<I,Couple<O,I>,E>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromChannel<I,O,E>(self:Channel<I,Couple<O,I>,E>):Reframe<I,O,E>{
    return lift(self.asRecallDef());
  }
}

class ReframeLift{
  static private function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  static private function unto<I,O,E>(wml:Arrowlet<Res<I,E>,Res<Couple<O,I>,E>>):Reframe<I,O,E> return new Reframe(wml.asRecallDef());
  
  static public function then<I,Oi,Oii,E>(self:Reframe<I,Oi,E>,that:Arrowlet<Res<Couple<Oi,I>,E>,Oii>):Arrowlet<Res<I,E>,Oii>{
    return Arrowlet._.then(self,that);
  }
  static public function attempt<I,O,Oi,E>(self:Reframe<I,O,E>,that:Attempt<O,Oi,E>):Reframe<I,Oi,E>{
    var fn = (chk:Res<Couple<Res<Oi,E>,I>,E>) -> (chk.flat_map(
      (tp) -> tp.fst().map(
        (r) -> __.couple(r,tp.snd())
      )
    ):Res<Couple<Oi,I>,E>);
    var arw =  unto(
      self.toChannel().process(
        that.first()
      ).postfix(fn)
    );
    return arw;
  }
  static public function arrange<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrange<O,I,Oi,E>):Reframe<I,Oi,E>{
    var arw = 
      self.then(that.toChannel())
        .broach()
        .postfix(
          (tp:Couple<Res<I,E>,Res<Oi,E>>) -> tp.swap().decouple(Res._.zip)
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
    return Channel.lift(self.toArw().postfix(o -> o.map(tp -> tp.fst())));
  }

  static public function execution<I,O,E>(self:Reframe<I,O,E>):Channel<I,I,E>{
    return Channel.lift(self.toArw().postfix(o -> o.map(tp -> tp.snd())));
  }
}