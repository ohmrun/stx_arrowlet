package stx.arw.lift;

class LiftProduceOfOptionIRToPropose{
  static public function toProduce<O,E>(self:Produce<Option<O>,E>):Propose<O,E>{
    return Propose.lift(self.toArrowlet().postfix(
      (res -> res.fold(
        opt -> opt.fold(Val,()->Tap),
        (e) -> End(e)
      ))
    ));
  }
}