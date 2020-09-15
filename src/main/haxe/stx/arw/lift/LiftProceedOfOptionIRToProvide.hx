package stx.arw.lift;

class LiftProceedOfOptionIRToProvide{
  static public function toProceed<O,E>(self:Proceed<Option<O>,E>):Provide<O,E>{
    return Provide.lift(self.toArrowlet().postfix(
      (res -> res.fold(
        opt -> opt.fold(Val,()->Tap),
        (e) -> End(e)
      ))
    ));
  }
}