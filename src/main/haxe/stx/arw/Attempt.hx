package stx.arw;
        
typedef AttemptDef<I,O,E>               = ArrowletDef<I,Res<O,E>,Noise>;

@:using(stx.arw.Attempt.AttemptLift)
@:forward abstract Attempt<I,O,E>(AttemptDef<I,O,E>) from AttemptDef<I,O,E> to AttemptDef<I,O,E>{
  static public var _(default,never) = AttemptLift;
  
  public function new(self) this = self;
  

  static public function lift<I,O,E>(self:AttemptDef<I,O,E>) return new Attempt(self);

  static public function unit<I,E>():Attempt<I,I,E>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<Res<I,E>,Noise>) -> {
          return cont.value(__.accept(i)).serve();
        }
      )
    );
  }
  @:noUsing static public function pure<I,O,E>(o:O):Attempt<I,O,E>{
    return fromRes(__.accept(o));
  }
  @:noUsing static public function fromRes<I,O,E>(res:Res<O,E>):Attempt<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (_:I,cont:Terminal<Res<O,E>,Noise>) -> {
          return cont.value(res).serve();
        }
      )
    );
  }
  
  @:from static public function fromFun1Res<Pi,O,E>(fn:Pi->Res<O,E>):Attempt<Pi,O,E>{
    return lift(Arrowlet.Anon(
      (pI:Pi,cont:Terminal<Res<O,E>,Noise>) -> {
        return cont.value(fn(pI)).serve();
      }
    ));
  }
  @:from static public function fromFun1Proceed<Pi,O,E>(fn:Pi->Proceed<O,E>):Attempt<Pi,O,E>{
    return lift(Arrowlet.Anon(
      (pI:Pi,cont:Terminal<Res<O,E>,Noise>) -> {
        return fn(pI).prepare(cont);
      }
    ));
  }
  @:from static public function fromUnary1Proceed<Pi,O,E>(fn:Unary<Pi,Proceed<O,E>>):Attempt<Pi,O,E>{
    return fromFun1Proceed(fn);
  }
  @:from static public function fromFun1Forward<Pi,O,E>(fn:Pi->Forward<O>):Attempt<Pi,O,E>{
    return lift(Arrowlet.Anon(
      (pI:Pi,cont:Terminal<Res<O,E>,Noise>) -> {
        return Proceed.lift(fn(pI).process(__.accept)).prepare(cont);
      }
    ));
  }
  @:noUsing static public function fromFun1R<I,O,E>(fn:I->O):Attempt<I,O,E>{
    return lift(
      Arrowlet.Anon((i,cont) -> cont.value(__.accept(fn(i))).serve())
    );
  }
  @:to public function toArrowlet():ArrowletDef<I,Res<O,E>,Noise>{
    return this;
  }
  public function toCascade():Cascade<I,O,E>{
    return Cascade.lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          (v) -> Arrowlet._.prepare(this,v,cont),
          (e) -> cont.value(__.reject(e)).serve()
        )
    ));  
  }
  public function environment(i:I,success:O->Void,failure:Err<E>->Void):Thread{
    return Cascade._.environment(this.toCascade(),i,success,failure);
  }
  public function prefix<Ii>(that:Ii->I):Attempt<Ii,O,E>{
    return Attempt._.prefix(this,that);
  }
  // static public function bind_fold<T,I,O,E>(arr:Array<T>,fn:T -> Attempt<I,O,E>):Attempt<T,O,E>{
  //   return arr.lfold(
  //     (next,memo) -> 
  //   )
  // }
}
class AttemptLift{
  static private function lift<I,O,E>(self:AttemptDef<I,O,E>)          return new Attempt(self);

  //static public function toArrowlet<I,O,E>(self:Attempt<I,O,E>):Arrowlet<I,O,E>{
    
  //}
  static public function then<I,O,Oi,E>(self:Attempt<I,O,E>,that:Cascade<O,Oi,E>):Attempt<I,Oi,E>{
    return lift(Arrowlet.Then(self,that));
  }
  static public function rectify<I,O,Oi,E>(self:Attempt<I,O,E>,next:Rectify<O,Oi,E>):Arrowlet<I,Oi,Noise>{
    return Arrowlet.lift(Arrowlet.Then(self.toArrowlet(),next.toArrowlet()));
  }
  static public function resolve<I,O,E>(self:Attempt<I,O,E>,next:Resolve<O,E>):Attempt<I,O,E>{
    return lift(self.then(next.toCascade()));
  }
  static public function reclaim<I,O,Oi,E>(self:Attempt<I,O,E>,next:Process<O,Proceed<Oi,E>>):Attempt<I,Oi,E>{
    return lift(
      then(
        self,
        next.toCascade()
      ).attempt(
        lift(Arrowlet.Anon(
          (prd:Proceed<Oi,E>,cont:Terminal<Res<Oi,E>,Noise>) ->
            prd.prepare(cont)
        ))
      )
    );
  }
  static public function recover<I,O,E>(self:Attempt<I,O,E>,next:Recover<O,E>):Attempt<I,O,E>{
    return lift(self.then(next.toCascade()));
  }
  static public function process<I,O,Oi,E>(self:Attempt<I,O,E>,next:Process<O,Oi>):Attempt<I,Oi,E>{
    return then(self,next.toCascade());
  }
  static public function errata<I,O,E,EE>(self:Attempt<I,O,E>,fn:Err<E>->Err<EE>):Attempt<I,O,EE>{
    return lift(self.postfix((oc) -> oc.errata(fn)));
  }
  static public function errate<I,O,E,EE>(self:Attempt<I,O,E>,fn:E->EE):Attempt<I,O,EE>{
    return lift(self.postfix((oc) -> oc.errate(fn)));
  }
  static public function attempt<I,O,Oi,E>(self:Attempt<I,O,E>,next:Attempt<O,Oi,E>):Attempt<I,Oi,E>{
    return then(self,next.toCascade());
  }
  static public function reframe<I,O,E>(self:Attempt<I,O,E>):Reframe<I,O,E>{ 
    return self.toCascade().reframe();
  }
  static public function forward<I,O,E>(self:Attempt<I,O,E>,i:I):Proceed<O,E>{
    return Proceed.lift(
      Arrowlet.Anon((_:Noise,cont) -> self.prepare(i,cont))
   );
  }  
  static public function arrange<I,O,Oi,E>(self:Attempt<I,O,E>,then:Arrange<O,I,Oi,E>):Attempt<I,Oi,E>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<Res<Oi,E>,Noise>) -> {
          var bound = Future.trigger();
          var inner = cont.inner(
            (outcome:Outcome<Res<O,E>,Noise>) -> {
              var input = outcome.fold(
                (res) -> res.fold(
                  (lhs) -> then.prepare(__.couple(lhs,i),cont),
                  (e)   -> cont.value(__.reject(e)).serve()
                ),
                (_)   -> cont.error(Noise).serve()
              );
              bound.trigger(input);
            }
          );
          var lhs = self.prepare(i,inner);
          return lhs.seq(bound);
        }
      )
    );
  }
  static public function prefix<I,Ii,O,E>(self:Attempt<I,O,E>,that:Ii->I):Attempt<Ii,O,E>{
    return lift(Arrowlet._.prefix(self.toArrowlet(),that));
  }
  static public function cascade<I,O,Oi,E>(self:Attempt<I,O,E>,that:Cascade<O,Oi,E>):Attempt<I,Oi,E>{
    return lift(self.then(that));
  }
}