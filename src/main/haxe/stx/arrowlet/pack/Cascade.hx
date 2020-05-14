package stx.arrowlet.pack;

typedef CascadeDef<I,O,E>               = ArrowletDef<Res<I,E>,Res<O,E>,Noise>;

@:using(stx.arrowlet.pack.Cascade.CascadeLift)
@:forward abstract Cascade<I,O,E>(CascadeDef<I,O,E>) from CascadeDef<I,O,E> to CascadeDef<I,O,E>{
  static public var _(default,never) = CascadeLift;
  public function new(self) this = self;
  
  static public function lift<I,O,E>(self:ArrowletDef<Res<I,E>,Res<O,E>,Noise>):Cascade<I,O,E>{
    return new Cascade(self);
  }
  static public function unit<I,O,E>():Cascade<I,I,E>{
    return lift(Arrowlet.fromFun1R(
      (oc:Res<I,E>) -> oc
    ));
  }
  static public function pure<I,O,E>(ocO:Res<O,E>):Cascade<I,O,E>{
    return lift(Arrowlet.fromFun1R(
      (ocI:Res<I,E>) -> ocI.fold(
        (i:I)               -> ocO,
        (e:Err<E>)   -> __.failure(e)
      )
    ));
  }
  static public function fromArrowlet<I,O,E>(arw:Arrowlet<I,O,E>):Cascade<I,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>) -> i.fold(
        (i:I) -> { 
          var defer     = Future.trigger();
          var inner     = cont.inner(
             (res:Outcome<O,E>) -> {
              var outer_res = Success(
                res.fold(
                  __.success,
                  (e:E) -> __.failure(__.fault().of(e))
                )
              );
              defer.trigger(outer_res);
            }
          );
          return cont.defer(defer).after(arw.prepare(i,inner));
        },
        (e:Err<E>) -> {
          return cont.value(__.failure(e)).serve();
        }
      )
    ));
  }
  static public function fromAttempt<I,O,E>(arw:Arrowlet<I,O,E>):Cascade<I,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>) -> i.fold(
        (i) -> {
          var defer = Future.trigger();
          var inner = cont.inner(
            (res:Outcome<O,E>) -> {
              defer.trigger(
                Success(res.fold(__.success,(e) -> __.failure(__.fault().of(e))))
              );
            }
          );
          return cont.defer(defer).after(arw.prepare(i,inner));
        },
        typical_fail_handler(cont)
      )
    ));
  }
  static public function fromProceed<O,E>(arw:Arrowlet<Noise,Res<O,E>,Noise>):Cascade<Noise,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Noise,E>,cont:Terminal<Res<O,E>,Noise>) -> i.fold(
        (_) -> arw.prepare(_,cont),
        typical_fail_handler(cont)
      )
    ));
  }
  static private function typical_fail_handler<O,E>(cont:Terminal<Res<O,E>,Noise>){
    return (e:Err<E>) -> {
      cont.value(__.failure(e)).serve();
    }
  }
  @:to public function toArrowlet():Arrowlet<Res<I,E>,Res<O,E>,Noise>{
    return this;
  }
  public function environment(i:I,success:O->Void,failure:Err<E>->Void):Thread{
    return _.environment(this,i,success,failure);
  }
}
class CascadeLift{
  static public function prepare<I,O,E>(self:Cascade<I,O,E>,i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>){
    return Arrowlet._.prepare(self,i,cont);
  }
  static private function lift<I,O,E>(self:ArrowletDef<Res<I,E>,Res<O,E>,Noise>):Cascade<I,O,E>{
    return new Cascade(self);
  }
  static public function or<Ii,Iii,O,E>(self:Cascade<Ii,O,E>,that:Cascade<Iii,O,E>):Cascade<Either<Ii,Iii>,O,E>{
    return lift(
      Arrowlet.Anon(
        (ipt:Res<Either<Ii,Iii>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
          switch(ipt){
            case Success(Left(l))       : self.prepare(Success(l),cont);
            case Success(Right(r))      : that.prepare(Success(r),cont);
            case Failure(e)             : typical_fail_handler(cont)(e);
          }
      )
    );
  }
  static public function errata<I,O,E,EE>(self:Cascade<I,O,E>,fn:Err<E>->Err<EE>):Cascade<I,O,EE>{
    return lift(
      Arrowlet.Anon(
        (i:Res<I,EE>,cont:Terminal<Res<O,EE>,Noise>) -> i.fold(
          (i) -> self.postfix(o -> o.errata(fn)).prepare(__.success(i),cont),
          typical_fail_handler(cont)
        )
      )
    );
  }
  static public function reframe<I,O,E>(self:Cascade<I,O,E>):Reframe<I,O,E>{ 
    return Reframe.lift(
      Arrowlet.Anon((ipt:Res<I,E>,cont:Terminal<Res<Couple<O,I>,E>,Noise>) -> {
        var defer = Future.trigger();
        var inner = cont.inner(
              (opt:Outcome<Res<O,E>,Noise>) -> {
                defer.trigger(
                  opt.map(res -> res.zip(ipt))
                );
              }    
            );
        return cont.defer(defer).after(
          self.prepare(ipt,inner)
        );
      })
    );
  }
  static public function then<I,O,Oi,E>(self:Cascade<I,O,E>,that:Cascade<O,Oi,E>):Cascade<I,Oi,E>{
    return lift(Arrowlet.Then(self,that));
  }
  static public function attempt<I,O,Oi,E>(self:Cascade<I,O,E>,that:Attempt<O,Oi,E>):Cascade<I,Oi,E>{
    return then(self,that.toCascade());  
  }
  static public function process<I,O,Oi,E>(self:Cascade<I,O,E>,that:Process<O,Oi>):Cascade<I,Oi,E>{
    return then(self,that.toCascade());
  }
  static public function postfix<I,O,Oi,E>(self:Cascade<I,O,E>,fn:O->Oi):Cascade<I,Oi,E>{
    return process(self,Process.fromFun1R(fn));
  }
  static public function prefix<I,Ii,O,E>(self:Cascade<I,O,E>,fn:Ii->I){
    return Cascade.fromArrowlet(Arrowlet.fromFun1R(fn)).then(self);
  }
  static function typical_fail_handler<O,E>(cont:Terminal<Res<O,E>,Noise>):Err<E> -> Work{
    return (e:Err<E>) -> {
      return cont.value(__.failure(e)).serve();
    }
  }
  static public function environment<I,O,E>(self:Cascade<I,O,E>,i:I,success:O->Void,failure:Err<E>->Void):Thread{
    return Arrowlet.Anon(
      (_:Noise,cont:Terminal<Noise,Noise>) -> {
        var defer = Future.trigger();
        var inner = cont.inner(
              (outcome:Outcome<Res<O,E>,Noise>) -> {
                  outcome.fold(
                    (res) -> {
                      res.fold(success,failure);
                      defer.trigger(Success(Noise));
                  },
                  (_)   -> {
                    defer.trigger(Failure(Noise));
                  }
                );
              }
            );
        var inner_response = self.prepare(__.success(i),inner);
        return cont.defer(defer).after(inner_response);
      }
    );
  }
}