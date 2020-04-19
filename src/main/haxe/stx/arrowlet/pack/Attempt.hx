package stx.arrowlet.pack;

typedef AttemptDef<I,O,E>               = ArrowletDef<I,Res<O,E>,Noise>;

@:using(stx.arrowlet.pack.Attempt.AttemptLift)
@:forward abstract Attempt<I,O,E>(AttemptDef<I,O,E>) from AttemptDef<I,O,E> to AttemptDef<I,O,E>{
  static public var _(default,never) = AttemptLift;
  
  public function new(self) this = self;
  

  static public function lift<I,O,E>(self:AttemptDef<I,O,E>) return new Attempt(self);

  static public function unit<I,E>():Attempt<I,I,E>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont:Terminal<Res<I,E>,Noise>) -> {
          cont.value(__.success(i));
          return cont.serve();
        }
      )
    );
  }
  static public function pure<I,O,E>(res:Res<O,E>):Attempt<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (_:I,cont:Terminal<Res<O,E>,Noise>) -> {
          cont.value(res);
          return cont.serve();
        }
      )
    );
  }
  
  @:from static public function fromFun1Res<Pi,O,E>(fn:Pi->Res<O,E>):Attempt<Pi,O,E>{
    return lift(Arrowlet.Anon(
      (pI:Pi,cont:Terminal<Res<O,E>,Noise>) -> {
        cont.value(fn(pI));
        return cont.serve();
      }
    ));
  }
  static public function fromFun1R<I,O,E>(fn:I->O):Attempt<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (i,cont) -> {
          cont.value(__.success(fn(i)));
          return cont.serve();
        }
      )
    );
  }
  @:to public function toArrowlet():ArrowletDef<I,Res<O,E>,Noise>{
    return this;
  }
  @:from static public function fromFun1Proceed<I,O,E>(fn:I->Proceed<O,E>):Attempt<I,O,E>{
    return lift(
      Arrowlet.Anon(
        (i:I,cont) -> fn(i).prepare(cont)
      )
    );
  }
}
class AttemptLift{
  static private function lift<I,O,E>(self:AttemptDef<I,O,E>)          return new Attempt(self);

  //static public function toArrowlet<I,O,E>(self:Attempt<I,O,E>):Arrowlet<I,O,E>{
    
  //}
  static public function then<I,O,Oi,E>(self:Attempt<I,O,E>,that:Cascade<O,Oi,E>):Attempt<I,Oi,E>{
    return lift(Arrowlet.Then(self,that));
  }
  static public function resolve<I,O,Oi,E>(self:Attempt<I,O,E>,next:Resolve<O,Oi,E>):Arrowlet<I,Oi,Noise>{
    return Arrowlet.lift(Arrowlet.Then(self.toArrowlet(),next.toArrowlet()));
  }
  static public function process<I,O,Oi,E>(self:Attempt<I,O,E>,next:Process<O,Oi>):Attempt<I,Oi,E>{
    return then(self,next.toCascade());
  }
  static public function errata<I,O,E,EE>(self:Attempt<I,O,E>,fn:Err<E>->Err<EE>):Attempt<I,O,EE>{
    return lift(self.postfix((oc) -> oc.errata(fn)));
  }
  static public function attempt<I,O,Oi,E>(self:Attempt<I,O,E>,next:Attempt<O,Oi,E>):Attempt<I,Oi,E>{
    return then(self,toCascade(next));
  }
  static public function reframe<I,O,E>(self:Attempt<I,O,E>):Reframe<I,O,E>{ 
    return toCascade(self).reframe();
  }
  static public function toCascade<I,O,E>(self:Attempt<I,O,E>):Cascade<I,O,E>{
    return Cascade.lift(Arrowlet.Anon(
      (i:Res<I,E>,cont:Terminal<Res<O,E>,Noise>) -> {
        return i.fold(
          (v) -> {
            return self.prepare(v,cont);
          },
          (e) -> {
            cont.value(__.failure(e));
            return cont.serve();
          }
        );
      }
    ));  
  }
  static public function forward<I,O,E>(self:Attempt<I,O,E>,i:I):Proceed<O,E>{
    return Proceed.lift(
      Arrowlet.Anon((_:Noise,cont) -> self.prepare(i,cont))
   );
  }  
}