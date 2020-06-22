package stx.arrowlet.pack;

typedef ArrangeDef<I,S,O,E>             = CascadeDef<Couple<I,S>,O,E>;
@:using(stx.arrowlet.pack.Arrange.ArrangeLift)
@:forward abstract Arrange<I,S,O,E>(ArrangeDef<I,S,O,E>) from ArrangeDef<I,S,O,E> to ArrangeDef<I,S,O,E>{
  static public var _(default,never) = ArrangeLift;

  public function new(self) this = self;
  @:noUsing static public function lift<I,S,O,E>(self:ArrangeDef<I,S,O,E>):Arrange<I,S,O,E>                         
    return new Arrange(self);

  @:noUsing static public function pure<I,S,O,E>(o:O):Arrange<I,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Couple<I,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          i -> cont.value(__.success(o)).serve(),
          e -> cont.value(__.failure(e)).serve()
        )
    ));
  }
  @:noUsing static public function fromRes<I,S,O,E>(res:Res<O,E>):Arrange<I,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Couple<I,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          i -> cont.value(res).serve(),
          e -> cont.value(__.failure(e)).serve()
        )
    ));
  }
  @:from static public function fromFun1Attempt<I,S,O,E>(f:I->Attempt<S,O,E>):Arrange<I,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Couple<I,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          i -> f(i.fst()).prepare(i.snd(),cont),
          e -> cont.value(__.failure(e)).serve()
        )
    ));
  }
  @:from static public function fromFunResAttempt<I,S,O,E>(f:Res<I,E>->Attempt<S,O,E>):Arrange<Res<I,E>,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Couple<Res<I,E>,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          i -> f(i.fst()).prepare(i.snd(),cont),
          e -> cont.value(__.failure(e)).serve()
        )
    ));
  }
  @:from static public function fromFun1Cascade<I,S,O,E>(f:I->Cascade<S,O,E>):Arrange<I,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Couple<I,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          i -> f(i.fst()).prepare(__.success(i.snd()),cont),
          e -> cont.value(__.failure(e)).serve()
        )
    ));
  }
  @:from static public function fromFunResCascade<I,S,O,E>(f:Res<I,E>->Cascade<S,O,E>):Arrange<Res<I,E>,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Res<Couple<Res<I,E>,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
        i.fold(
          (i) -> f(i.fst()).prepare(__.success(i.snd()),cont),
          (e) -> cont.value(__.failure(e)).serve()
        )
    ));
  }
  @:noUsing static public function bind_fold<I,S,E,T>(fn:T->I->Cascade<S,I,E>,iterable:Iterable<T>):Option<Arrange<I,S,I,E>>{
    return iterable
     .toIter()
     .map(_ -> (fn.bind1(_):I->Cascade<S,I,E>))
     .map(fromFun1Cascade)
     .lfold1(
       (next:Arrange<I,S,I,E>,memo:Arrange<I,S,I,E>) ->  {
         return Arrange.lift(_.state(memo).then(next.toArrowlet()));
       }
     );
   }
   @:from static public function fromFun2R<I,S,O,E>(fn:I->S->O):Arrange<I,S,O,E>{
    return modifier(fn);
   }
   @:noUsing static public function modifier<I,S,O,E>(fn:I->S->O):Arrange<I,S,O,E>{
     return lift(
       Arrowlet.Anon(
         (res:Res<Couple<I,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> 
            res.fold( 
              __.decouple((i:I,s:S) -> cont.value(__.success(fn(i,s))).serve()),
              (e) -> cont.value(__.failure(e)).serve()
          )
       )
     );
   }
   //success:O->Void,failure:Err<E>->Void
   public function prepare(i:Couple<I,S>,cont:Terminal<Res<O,E>, Noise>):Work{
     return Cascade._.prepare(
       this,
       __.success(i),
       cont
     );
   }
   @:to public function toArrowlet():Arrowlet<Res<Couple<I,S>,E>,Res<O,E>,Noise>{
     return this;
   }
   @:to public function toCascade():Cascade<Couple<I,S>,O,E>{
    return this;
  }

}
class ArrangeLift{
  static public function state<I,S,O,E>(self:Arrange<I,S,O,E>):Cascade<Couple<I,S>,Couple<O,S>,E>{
    return Attempt.lift(
      self.broach().postfix(
      __.decouple(
        (tp:Res<Couple<I,S>,E>,chk:Res<O,E>) -> tp.map(_ -> _.snd()).zip(chk).map(
          (tp) -> tp.swap()
        )
      )
    ));
  }
  static public function attempt<I,S,O,Oi,E>(self:Arrange<I,S,O,E>,attempt:Attempt<O,Oi,E>):Arrange<I,S,Oi,E>{
    return Arrange.lift(
      self.then(
        attempt.toCascade()
      )
    );
  }
  static public function errata<I,S,O,E,EE>(self:Arrange<I,S,O,E>,fn:Err<E>->Err<EE>):Arrange<I,S,O,EE>{
    return Arrange.lift(
      Arrowlet.Anon(
        (res:Res<Couple<I,S>,EE>,cont:Terminal<Res<O,EE>,Noise>) -> res.fold(
          i -> self.then( (res:Res<O,E>) -> res.errata(fn) ).prepare(__.success(i),cont),
          e -> cont.value(__.failure(e)).serve()
        )
      )
    );
  }
  static public function errate<I,S,O,E,EE>(self:Arrange<I,S,O,E>,fn:E->EE):Arrange<I,S,O,EE>{
    return Arrange.lift(errata(self,(oc) -> oc.map(fn)));
  }
  static public function process<I,S,O,Oi,E>(self:Arrange<I,S,O,E>,that:Process<O,Oi>):Arrange<I,S,Oi,E>{
    return Arrange.lift(
      Cascade._.process(self,that)     
    );
  }
  static public function cover<I,S,O,E>(self:Arrange<I,S,O,E>,i:I):Cascade<S,O,E>{
    return Cascade.lift(
      Arrowlet.Anon(
        (res:Res<S,E>,cont:Terminal<Res<O,E>,Noise>) -> res.fold(
          v -> self.prepare(__.couple(i,v),cont),
          e -> cont.value(__.failure(e)).serve()
        )
      )
    );
  }
  //static public function arrange<I,S,O,Oi,E>(self:Arrange<I,S,O,E>,that:Arrange<)
}