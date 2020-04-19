package stx.arrowlet.pack;

typedef ArrangeDef<I,S,O,E>             = AttemptDef<Couple<I,S>,O,E>;
@:using(stx.arrowlet.pack.Arrange.ArrangeLift)
@:forward abstract Arrange<I,S,O,E>(ArrangeDef<I,S,O,E>) from ArrangeDef<I,S,O,E> to ArrangeDef<I,S,O,E>{
  static public var _(default,never) = ArrangeLift;

  public function new(self) this = self;
  static public function lift<I,S,O,E>(self:ArrangeDef<I,S,O,E>):Arrange<I,S,O,E>                         
    return new Arrange(self);

  static public function pure<I,S,O,E>(o:O):Arrange<I,S,O,E>{
    return lift(Arrowlet.Anon(
      (i:Couple<I,S>,cont:Terminal<Res<O,E>,Noise>) ->  {
        cont.value(__.success(o));
        return cont.serve();
      }
    ));
  }
  @:from static public function fromFun1Attempt<I,S,O,E>(f:I->Attempt<S,O,E>):Arrange<I,S,O,E>{
    var fN =  Attempt.lift(Arrowlet.unit().postfix(
      __.decouple(
        (l:I,r:S) -> (__.couple(Arrowlet.lift(f(l).asArrowletDef()),r):Couple<Arrowlet<S,Res<O,E>,Noise>,S>)
      )
    ).then(Arrowlet.Apply()));
    return lift(fN.asArrowletDef());
  }
  @:noUsing static public function bind_fold<I,S,E,T>(fn:T->I->Attempt<S,I,E>,array:Array<T>):Option<Arrange<I,S,I,E>>{
    return array
     .map(_ -> (fn.bind1(_):I->Attempt<S,I,E>))
     .map(fromFun1Attempt)
     .lfold1(
       (next:Arrange<I,S,I,E>,memo:Arrange<I,S,I,E>) ->  {
         return Arrange.lift(_.state(memo).attempt(Attempt.lift(next)));
       }
     );
   }
}
class ArrangeLift{
  static public function state<I,S,O,E>(self:Arrange<I,S,O,E>):Attempt<Couple<I,S>,Couple<O,S>,E>{
    return Attempt.lift(
      self.broach().postfix(
      __.decouple(
        (tp:Couple<I,S>,chk:Res<O,E>) -> chk.map(__.couple.bind(_,tp.snd()))
      )
    ));
  }
  static public function toCascade<I,S,O,E>(self:Arrange<I,S,O,E>):Cascade<Couple<I,S>,O,E>{
    return Cascade.lift(
      Arrowlet.Anon((i:Res<Couple<I,S>,E>,cont:Terminal<Res<O,E>,Noise>) -> {
        return i.fold(
          (tp)  -> self.prepare(tp,cont),
          (err) -> {
            cont.value(__.failure(err));
            cont.serve();
          }
        );
      }
    ));
  }
}