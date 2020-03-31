package stx.channel.pack;

@:using(stx.arrowlet.core.pack.Arrowlet.ArrowletLift)
@:using(stx.channel.pack.Arrange.ArrangeLift)
@:forward abstract Arrange<I,S,O,E>(ArrangeDef<I,S,O,E>) from ArrangeDef<I,S,O,E> to ArrangeDef<I,S,O,E>{
  static public var _(default,never) = ArrangeLift;

  public function new(self) this = self;
  static public function lift<I,S,O,E>(self:ArrangeDef<I,S,O,E>):Arrange<I,S,O,E>                         
    return new Arrange(self);
  static public function unto<I,S,O,E>(self:Arrowlet<Couple<I,S>,Res<O,E>>):Arrange<I,S,O,E>          
    return new Arrange(self.asRecallDef());

  static public function pure<I,S,O,E>(o:O):Arrange<I,S,O,E>{
    return unto(Arrowlet.fromFun1R(
      (i:Couple<I,S>) ->  __.success(o)
    ));
  }
  static public function fromFun1Attempt<I,S,O,E>(f:I->Attempt<S,O,E>):Arrange<I,S,O,E>{
    var fN =  Attempt.lift(Arrowlet.unit().postfix(
      __.decouple(
        (l:I,r:S) -> (__.couple(Arrowlet.lift(f(l).asRecallDef()),r):Couple<Arrowlet<S,Res<O,E>>,S>)
      )
    ).then(Arrowlet.Apply()));
    return lift(fN.asRecallDef());
  }
  static public function bind_fold<I,S,E,T>(fn:T->I->Attempt<S,I,E>,array:Array<T>):Option<Arrange<I,S,I,E>>{
    return array
     .map(_ -> (fn.bind1(_):I->Attempt<S,I,E>))
     .map(fromFun1Attempt)
     .lfold1(
       (next:Arrange<I,S,I,E>,memo:Arrange<I,S,I,E>) ->  {
         return Arrange.lift(memo.state().attempt(next.toArw()));
       }
     );
   }

  @:to public function toArw():Arrowlet<Couple<I,S>,Res<O,E>>{
    return Arrowlet.lift(this.asRecallDef());
  }
  @:from static public function fromArw<I,S,O,E>(self:Arrowlet<Couple<I,S>,Res<O,E>>):Arrange<I,S,O,E>{
    return lift(self.asRecallDef());
  }
}
class ArrangeLift{
  static public function state<I,S,O,E>(self:Arrange<I,S,O,E>):Attempt<Couple<I,S>,Couple<O,S>,E>{
    return Attempt.lift(
      self.toArw().broach().postfix(
      __.decouple(
        (tp:Couple<I,S>,chk:Res<O,E>) -> chk.map(__.couple.bind(_,tp.snd()))
      )
    ));
  }
}