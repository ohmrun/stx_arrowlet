package stx.arw;

typedef ReframeDef<I,O,E>               = CascadeDef<I,Couple<O,I>,E>;

@:using(stx.arw.Reframe.ReframeLift)
@:using(stx.arw.Arrowlet.ArrowletLift)
@:forward abstract Reframe<I,O,E>(ReframeDef<I,O,E>) from ReframeDef<I,O,E> to ReframeDef<I,O,E>{
  static public var _(default,never) = ReframeLift;

  public function new(self) this = self;

  @:noUsing static public function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  @:noUsing static public function pure<I,O,E>(o:O):Reframe<I,O,E>{
    return lift(Arrowlet._.postfix(
      Cascade.unit(),
      (oc:Res<I,E>) -> (oc.map(__.couple.bind(o)):Res<Couple<O,I>,E>)
    ));
  }
  
  

  private var self(get,never):Reframe<I,O,E>;
  private function get_self():Reframe<I,O,E> return this;


  @:to public function toCascade():Cascade<I,Couple<O,I>,E>{
    return Cascade.lift(this);
  }
  @:to public function toArrowlet():Arrowlet<Res<I,E>,Res<Couple<O,I>,E>,Noise>{
    return Arrowlet.lift(this);
  }
  @:from static public function fromCascade<I,O,E>(self:Cascade<I,Couple<O,I>,E>):Reframe<I,O,E>{
    return lift(self);
  }
}

class ReframeLift{
  static private function lift<I,O,E>(wml:ReframeDef<I,O,E>):Reframe<I,O,E> return new Reframe(wml);
  
  static public function cascade<I,Oi,Oii,E>(self:Reframe<I,Oi,E>,that:Cascade<Couple<Oi,I>,Oii,E>):Cascade<I,Oii,E>{
    return Cascade.lift(Arrowlet.Then(self,that));
  }
  static public function attempt<I,O,Oi,E>(self:Reframe<I,O,E>,that:Attempt<O,Oi,E>):Reframe<I,Oi,E>{
    var fn = (chk:Res<Couple<Res<Oi,E>,I>,E>) -> (chk.flat_map(
      (tp) -> tp.fst().map(
        (r) -> __.couple(r,tp.snd())
      )
    ):Res<Couple<Oi,I>,E>);
    var arw =  lift(
      Arrowlet._.postfix(self.toCascade().process(
        Process.lift(that.toArrowlet().first())
      ),fn)
    );
    return arw;
  }
  
  static public function rearrange<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrange<Res<O,E>,I,Oi,E>):Reframe<I,Oi,E>{
    return Reframe.lift(
      Arrowlet.Anon(
        (ipt:Res<I,E>,cont:Terminal<Res<Couple<Oi,I>,E>,Noise>) -> {
          //trace(ipt);
          var waits : FutureTrigger<Work> = Future.trigger();
          var waitsII                     = Future.trigger();
          var inner = cont.inner(
            (outcome:Outcome<Res<Couple<O,I>,E>,Noise>) -> {
              //trace(outcome);
              var innerI = cont.inner(
                (outcome:Outcome<Res<Oi,E>,Noise>) -> {
                  var val = ipt.fold((i) -> outcome.fold(
                      (res) -> Success(res.fold(
                          (oI)  -> __.accept(__.couple(oI,i)),
                          (e)   -> __.reject(e)
                        )),
                      (e) ->  Failure(e)
                    ),
                    (e) ->  Success(__.reject(e))
                  );
                  //trace(val);
                  var job   = cont.issue(val);
                  var work  = job.serve();
                  waitsII.trigger(work);
                }
              );
              var value = outcome.fold(
                (res) -> {
                  //trace(res);
                  var val = ipt.fold(
                    (i:I) -> {
                      var iptI = __.couple(res.map(_ -> _.fst()),i);
                      return Arrowlet._.prepare(that.toArrowlet(),__.accept(iptI),innerI);
                    },
                    (e) -> cont.value(__.reject(e)).serve()
                  );
                  val;
                },
                (_) -> cont.error(Noise).serve()
              );
              //trace(value);
              waits.trigger(value);
            }
          );
          var workI = self.prepare(ipt,inner);
          return workI.seq(waits).seq(waitsII);
        }
      )
    );
  }
  //static public function process<I,O,Oi,E>(self:Reframe<I,O,E>,that:Process<O,Oi>):Reframe<I,O,E>{
    //return self.
 // }
  static public function arrange<I,O,Oi,E>(self:Reframe<I,O,E>,that:Arrange<O,I,Oi,E>):Reframe<I,Oi,E>{
    var arw = 
      Arrowlet._.postfix(
        cascade(self,that).broach(),
        (res:Res<Couple<I,Oi>,E>) -> {
            return res.map(tp -> tp.swap());
          }
        );
    return Reframe.lift(arw);
  }

  static public function arrangement<I,Ii,O,Oi,E>(self:Reframe<I,O,E>,that:O->Arrange<Ii,I,Oi,E>):Attempt<Couple<Ii,I>,Oi,E>{
    return Attempt.lift(Arrowlet.Anon(
      (ipt:Couple<Ii,I>,cont:Terminal<Res<Oi,E>,Noise>) -> {
        var defer = Future.trigger();
        var inner = cont.inner(
          (chk:Outcome<Res<Couple<O,I>,E>,Noise>) -> switch(chk){
            case Success(Accept(tp)) : 
              defer.trigger(
                that(tp.fst()).prepare(__.couple(ipt.fst(),tp.snd()),cont)
              );null;
            case Failure(_) :
              defer.trigger(cont.error(Noise).serve());null;
            case Success(Reject(e)) : 
              defer.trigger(cont.value(__.reject(e)).serve());null;
          }
          
        );
        return self.prepare(__.accept(ipt.snd()),inner).seq(defer);
      }
    ));
  }

  static public function commandment<I,O,E>(self:Reframe<I,O,E>,fn:O->Command<I,E>):Reframe<I,O,E>{
    return lift(Arrowlet.Anon(
      (ipt:Res<I,E>,cont:Terminal<Res<Couple<O,I>,E>,Noise>) -> {
        var defer = Future.trigger();
        var inner = cont.inner(
          (out:Outcome<Res<Couple<O,I>,E>,Noise>) -> switch(out){
            case Success(Accept(tp)) : 
              defer.trigger(fn(tp.fst()).postfix(
                (opt) -> opt.fold(
                  (err) -> __.reject(err),
                  ()    -> __.accept(tp)
                )
              ).prepare(tp.snd(),cont));null;
            case Success(Reject(e))  : 
              defer.trigger(cont.value(__.reject(e)).serve());null;
            default : 
              defer.trigger(cont.error(Noise).serve());null;
          }
        );
        return self.prepare(ipt,inner).seq(defer);
      }
    ));
  }
  static public function evaluation<I,O,E>(self:Reframe<I,O,E>):Cascade<I,O,E>{
    return Cascade.lift(self.postfix(o -> o.map(tp -> tp.fst())));
  }

  static public function execution<I,O,E>(self:Reframe<I,O,E>):Cascade<I,I,E>{
    return Cascade.lift(self.postfix(o -> o.map(tp -> tp.snd())));
  }
  static public function errate<I,O,E,EE>(self:Reframe<I,O,E>,fn:E->EE):Reframe<I,O,EE>{
    return lift(
      Arrowlet.Anon(
        (i:Res<I,EE>,cont:Terminal<Res<Couple<O,I>,EE>,Noise>) -> i.fold(
          (i) -> self.postfix(o -> o.errata((e) -> e.map(fn))).prepare(__.accept(i),cont),
          (e) -> cont.value(__.reject(e)).serve()
        )
      )
    );
  }
  static public function environment<I,O,E>(self:Reframe<I,O,E>,i:I,success:Couple<O,I>->Void,failure:Err<E>->Void):Thread{
    return Cascade._.environment(
      self,
      i,
      success,
      failure
    );
  }
  
  //static public function modify<I,Oi,Oii,E>(self:Reframe<I,Oi,E>,fn:Oi->)
  static public function process<I,O,Oi,E>(self:Reframe<I,O,E>,fn:Process<O,Oi>):Reframe<I,Oi,E>{
    return lift(self.cascade(
      fn.first().toCascade()
    ));
  }
}