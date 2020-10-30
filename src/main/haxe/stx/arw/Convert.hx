package stx.arw;

typedef ConvertDef<I,O> = ArrowletDef<I,O,Noise>;

/**
  An Arrowlet with no fail case
**/
@:using(stx.arw.Convert.ConvertLift)
abstract Convert<I,O>(ConvertDef<I,O>) from ConvertDef<I,O> to ConvertDef<I,O>{
  static public var _(default,never) = ConvertLift;
  public inline function new(self) this = self;
  @:noUsing static public function lift<I,O>(self:ConvertDef<I,O>):Convert<I,O> return new Convert(self);
  @:noUsing static public function unit<I>():Convert<I,I> return lift(Arrowlet.Sync((i:I)->i));

  @:noUsing static public function fromFun1Provide<I,O>(self:I->Provide<O>):Convert<I,O>{
    return fromConvertProvide(self);
  }
  @:noUsing static public function fromConvertProvide<I,O>(self:Convert<I,Provide<O>>):Convert<I,O>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<O,Noise>) -> {
          var defer = Future.trigger();
          var inner = cont.inner(
            (res:Outcome<Provide<O>,Array<Noise>>) -> {
              defer.trigger(
                res.fold(
                  (ok)  -> Arrowlet._.prepare(ok,Noise,cont),
                  (e)   -> cont.error(e).serve()
                )
              );
            }
          );
          var value = Arrowlet._.prepare(self.toArrowlet(),i,inner); 
          return value.seq(defer);
        }
      )
    );
  }
  
  public function toArrowlet():ArrowletDef<I,O,Noise>{
    return this;
  }
  private var self(get,never):Convert<I,O>;
  private function get_self():Convert<I,O> return lift(this);

  public function toCascade<E>():Cascade<I,O,E>{
    return Cascade.lift(
      Arrowlet.Anon(
        (i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>) ->
          i.fold(
            (i) -> {
              var defer : FutureTrigger<Outcome<Res<O,E>,Array<Noise>>> = Future.trigger();
              var inner = cont.inner(
                (outcome:Outcome<O,Array<Noise>>) -> {
                  defer.trigger(outcome.fold(
                    (s) -> Success(__.accept(s)),
                    (_) -> Failure([Noise])
                  ));
                }
              );
              return cont.later(defer).after(this.prepare(i,inner));
            },
            (err) -> {
              return cont.value(__.reject(err)).serve();
            }
          )
      )
    );
  }
  @:from static public function fromFun1R<I,O>(fn:I->O):Convert<I,O>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<O,Noise>) -> {
          return cont.value(fn(i)).serve();
        }
      )
    );
  }
  
  @:from static public function fromArrowlet<I,O>(arw:Arrowlet<I,O,Noise>){
    return lift(arw);
  }
  public function environment(i:I,success:O->Void):Thread{
    return Arrowlet._.environment(
      this,
      i,
      success,
      __.crack
    );
  }
}
class ConvertLift{
  static public function then<I,O,Oi>(self:ConvertDef<I,O>,that:Convert<O,Oi>):Convert<I,Oi>{
    return Convert.lift(Arrowlet.Then(
      self,
      that
    ));
  }
  static public function provide<I,O,Oi>(self:ConvertDef<I,O>,i:I):Provide<O>{
    return Provide.lift(Arrowlet._.fulfill(self,i));
  }
  static public function convert<I,O,Oi>(self:ConvertDef<I,O>,that:ConvertDef<O,Oi>):Convert<I,Oi>{
    return Convert.lift(
      Arrowlet.Then(
        self,
        that
      )
    );
  }
  static public function first<I,Ii,O>(self:Convert<I,O>):Convert<Couple<I,Ii>,Couple<O,Ii>>{
    return Convert.lift(Arrowlet._.first(self.toArrowlet()));
  }
  static public function fudge<I,O>(self:Convert<I,O>):Provide<O>{
    return Provide.lift(
      Arrowlet.Anon(
        (_:Noise,cont:Terminal<O,Noise>) -> Arrowlet._.prepare(self.toArrowlet(),null,cont)
      )
    );
  }
  static public inline function prepare<I,O>(self:Convert<I,O>,ipt:I,cont:Terminal<O,Noise>):Work{
    return Arrowlet._.prepare(self.toArrowlet(),ipt,cont);
  }
}